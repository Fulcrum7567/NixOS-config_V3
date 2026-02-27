{ config, lib, pkgs-default, ... }:
let 
  cfg = config.server.services.nextcloud;
  ssoCfg = config.server.services.singleSignOn;
  domain = "${cfg.subdomain}.${config.server.webaddress}";
  clientId = "nextcloud";
in 
{
  config = lib.mkIf cfg.enable {

    # ──────────────────────────────────────────────────────────
    #  Sops Secrets
    # ──────────────────────────────────────────────────────────

    sops.secrets = {
      # Admin password for initial Nextcloud setup
      "nextcloud/adminPassword" = {
        owner = cfg.serviceUsername;
        group = cfg.serviceGroup;
        sopsFile = ./nextcloudSecrets.yaml;
        format = "yaml";
        key = "nextcloud_admin_password";
        restartUnits = [ "nextcloud-setup.service" ];
      };

      # OAuth client secret – readable by kanidm for provisioning
      "nextcloud/oauth/client_secret" = {
        owner = ssoCfg.serviceUsername;
        group = ssoCfg.serviceGroup;
        sopsFile = ./nextcloudSecrets.yaml;
        format = "yaml";
        key = "nextcloud_client_secret";
        restartUnits = [ "kanidm.service" ];
        mode = "0440";
      };

      # Same secret, but readable by Nextcloud for OIDC config
      "nextcloud/clientSecret" = {
        owner = cfg.serviceUsername;
        group = cfg.serviceGroup;
        sopsFile = ./nextcloudSecrets.yaml;
        format = "yaml";
        key = "nextcloud_client_secret";
        restartUnits = [ "nextcloud-setup.service" ];
      };
    };

    # ──────────────────────────────────────────────────────────
    #  Data directory on /data partition (bind mount)
    # ──────────────────────────────────────────────────────────

    systemd.tmpfiles.rules = [
      "d ${cfg.defaultDataDir} 0750 ${cfg.serviceUsername} ${cfg.serviceGroup} - -"
      "Z ${cfg.defaultDataDir} 0750 ${cfg.serviceUsername} ${cfg.serviceGroup} - -"
    ];

    fileSystems."/var/lib/nextcloud" = {
      device = cfg.defaultDataDir;
      options = [ "bind" ];
    };

    # ──────────────────────────────────────────────────────────
    #  Nextcloud Service
    # ──────────────────────────────────────────────────────────

    services.nextcloud = {
      enable = true;
      package = cfg.package;
      hostName = domain;
      https = true;
      maxUploadSize = cfg.maxUploadSize;

      config = {
        adminuser = cfg.adminUsername;
        adminpassFile = config.sops.secrets."nextcloud/adminPassword".path;

        # Use PostgreSQL for production
        dbtype = "pgsql";
      };

      database.createLocally = true;

      # Performance tuning
      configureRedis = true;
      caching = {
        redis = true;
        apcu = true;
      };

      # Recommended Nextcloud settings
      settings = {
        # Trusted domains & proxy config
        trusted_domains = [ domain ];
        trusted_proxies = [ "127.0.0.1" "::1" ];
        overwriteprotocol = "https";
        overwritehost = domain;
        default_phone_region = "DE";

        # Logging
        loglevel = 2;
        log_type = "file";

        # Maintenance window for background jobs (UTC, 1-5 AM)
        maintenance_window_start = 1;
      };

      # phpOptions for performance
      phpOptions = {
        "opcache.interned_strings_buffer" = "16";
        "opcache.max_accelerated_files" = "10000";
        "opcache.memory_consumption" = "128";
        "opcache.revalidate_freq" = "1";
      };

      # Declarative apps
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
          user_oidc  # OpenID Connect user backend for Kanidm SSO
          ;
      } // cfg.extraApps;
      extraAppsEnable = true;

      # Enable auto-updates for the database schema
      autoUpdateApps.enable = true;
    };

    # ──────────────────────────────────────────────────────────
    #  Systemd hardening & ownership fix
    # ──────────────────────────────────────────────────────────

    systemd.services.nextcloud-setup = {
      unitConfig.RequiresMountsFor = "/var/lib/nextcloud";
      # Append sops to the after list (the NixOS module already sets
      # after = [ "postgresql.target" ] via requires/after).
      after = [ "sops-nix.service" "postgresql.target" ];
      requires = [ "postgresql.target" ];

      # Fix ownership before the upstream setup script checks it.
      # Runs as root (preStart always runs as root even when User= is set).
      preStart = lib.mkBefore ''
        # Ensure the bind mount target dirs exist with correct ownership
        ${pkgs-default.coreutils}/bin/install -d -m 0750 -o ${cfg.serviceUsername} -g ${cfg.serviceGroup} /var/lib/nextcloud
        ${pkgs-default.coreutils}/bin/install -d -m 0750 -o ${cfg.serviceUsername} -g ${cfg.serviceGroup} /var/lib/nextcloud/config
        ${pkgs-default.coreutils}/bin/install -d -m 0750 -o ${cfg.serviceUsername} -g ${cfg.serviceGroup} /var/lib/nextcloud/data
        ${pkgs-default.coreutils}/bin/install -d -m 0750 -o ${cfg.serviceUsername} -g ${cfg.serviceGroup} /var/lib/nextcloud/store-apps

        # Recursively fix ownership in case of leftover files from failed installs
        ${pkgs-default.coreutils}/bin/chown -R ${cfg.serviceUsername}:${cfg.serviceGroup} /var/lib/nextcloud
      '';
    };

    systemd.services.phpfpm-nextcloud = {
      unitConfig.RequiresMountsFor = "/var/lib/nextcloud";
    };

    # ──────────────────────────────────────────────────────────
    #  Nginx – Nextcloud manages its own vhost via services.nextcloud
    #  We just need to configure TLS on it using your wildcard cert
    # ──────────────────────────────────────────────────────────

    services.nginx.virtualHosts.${domain} = {
      forceSSL = true;
      useACMEHost = config.server.webaddress;
    };

    # ──────────────────────────────────────────────────────────
    #  OIDC configuration via occ (semi-declarative)
    #  The user_oidc app must be configured after nextcloud-setup
    # ──────────────────────────────────────────────────────────

    systemd.services.nextcloud-oidc-setup = {
      description = "Configure Nextcloud OIDC provider for Kanidm SSO";
      wantedBy = [ "multi-user.target" ];
      after = [ "nextcloud-setup.service" "phpfpm-nextcloud.service" ];
      requires = [ "nextcloud-setup.service" "phpfpm-nextcloud.service" ];

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        RemainAfterExit = true;
      };

      path = [ config.services.nextcloud.occ pkgs-default.jq ];

      script = let
        issuerUrl = "https://${ssoCfg.subdomain}.${config.server.webaddress}/oauth2/openid/${clientId}";
        discoveryUrl = "${issuerUrl}/.well-known/openid-configuration";
        ssoDisplayName = "Login with Kanidm";
      in ''
        set -euo pipefail

        CLIENT_SECRET=$(cat "${config.sops.secrets."nextcloud/clientSecret".path}")

        # Disable local login so users go through SSO
        nextcloud-occ config:app:set user_oidc allow_multiple_user_backends --value="0"

        # Check if provider already exists
        EXISTING=$(nextcloud-occ user_oidc:provider -h 2>&1 || true)

        # Create or update the OIDC provider
        # user_oidc:provider expects: <identifier> --clientid --clientsecret --discoveryuri
        if nextcloud-occ user_oidc:provider "${ssoDisplayName}" \
          --clientid="${clientId}" \
          --clientsecret="$CLIENT_SECRET" \
          --discoveryuri="${discoveryUrl}" \
          --scope="openid email profile" \
          --unique-uid=0 \
          --check-bearer=1 \
          --mapping-uid="preferred_username" \
          --mapping-display-name="name" \
          --mapping-email="email" \
          2>&1; then
          echo "✅ OIDC provider configured successfully"
        else
          echo "⚠️  OIDC provider command returned non-zero, may already exist (updating...)"
          # Try update approach – remove and re-add
          nextcloud-occ user_oidc:provider:remove "${ssoDisplayName}" 2>/dev/null || true
          nextcloud-occ user_oidc:provider "${ssoDisplayName}" \
            --clientid="${clientId}" \
            --clientsecret="$CLIENT_SECRET" \
            --discoveryuri="${discoveryUrl}" \
            --scope="openid email profile" \
            --unique-uid=0 \
            --check-bearer=1 \
            --mapping-uid="preferred_username" \
            --mapping-display-name="name" \
            --mapping-email="email"
          echo "✅ OIDC provider updated successfully"
        fi

        # Auto-redirect to SSO provider (skip Nextcloud login page)
        nextcloud-occ config:app:set user_oidc auto_redirect_to_provider --value="${ssoDisplayName}" || true

        # Declaratively disable unwanted bundled apps
        ${lib.concatMapStringsSep "\n" (app: ''nextcloud-occ app:disable ${app} || true'') cfg.disabledApps}

        # Run mimetype migrations if available (one-time, safe to re-run)
        nextcloud-occ maintenance:repair --include-expensive || true

        echo "✅ Nextcloud OIDC setup complete"
      '';
    };

    # ──────────────────────────────────────────────────────────
    #  Reverse Proxy (your custom abstraction)
    #  Since Nextcloud's NixOS module creates its own nginx vhost,
    #  we do NOT add an activeRedirects entry – nginx handles it directly.
    #  But we DO need the extraHosts entry for internal resolution.
    # ──────────────────────────────────────────────────────────

    networking.extraHosts = ''
      127.0.0.1 ${domain}
    '';

    # ──────────────────────────────────────────────────────────
    #  Kanidm SSO – register Nextcloud as OAuth2 client
    # ──────────────────────────────────────────────────────────

    server.services.singleSignOn.oAuthServices."${clientId}" = {
      displayName = "Nextcloud";
      originUrl = [
        "https://${domain}/apps/user_oidc/code"
        "https://${domain}/"
      ];
      originLanding = "https://${domain}";
      basicSecretFile = config.sops.secrets."nextcloud/oauth/client_secret".path;
      preferShortUsername = true;
      imageFile = ./nextcloud.svg;
      groupName = "nextcloud_users";
      scopes = [ "openid" "profile" "email" ];
    };

  };
}