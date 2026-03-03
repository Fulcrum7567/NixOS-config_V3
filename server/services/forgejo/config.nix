{ config, lib, pkgs-default, ... }:
let
  cfg = config.server.services.forgejo;
  ssoCfg = config.server.services.singleSignOn;
  domain = "${cfg.subdomain}.${config.server.webaddress}";
  clientId = "forgejo";
in
{
  config = lib.mkIf cfg.enable {

    # --- SOPS Secrets ---

    sops.secrets."forgejo/oauth/client_secret" = {
      owner = ssoCfg.serviceUsername;
      group = ssoCfg.serviceGroup;
      sopsFile = ./forgejoSecrets.yaml;
      format = "yaml";
      key = "forgejo_client_secret";
      restartUnits = [ "kanidm.service" ];
      mode = "0440";
    };

    sops.secrets."forgejo/clientSecret" = {
      owner = cfg.serviceUsername;
      group = cfg.serviceGroup;
      sopsFile = ./forgejoSecrets.yaml;
      format = "yaml";
      key = "forgejo_client_secret";
      restartUnits = [ "forgejo.service" ];
    };

    # --- Data Directory & Bind Mount ---

    systemd.tmpfiles.rules = [
      "d ${cfg.defaultDataDir} 0750 ${cfg.serviceUsername} ${cfg.serviceGroup} - -"
      "Z ${cfg.defaultDataDir} 0750 ${cfg.serviceUsername} ${cfg.serviceGroup} - -"
    ];

    fileSystems."/var/lib/forgejo" = {
      device = cfg.defaultDataDir;
      options = [ "bind" ];
    };

    # --- Forgejo Service ---

    services.forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = cfg.lfsEnable;
      settings = {
        server = {
          DOMAIN = domain;
          ROOT_URL = "https://${domain}/";
          HTTP_PORT = cfg.port;
          HTTP_ADDR = "::1";
          SSH_PORT = lib.head config.services.openssh.ports;
          SSH_DOMAIN = domain;
        };
        service = {
          DISABLE_REGISTRATION = false;
          ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          ENABLE_BASIC_AUTHENTICATION = false;
          ENABLE_INTERNAL_SIGNIN = false;
        };
        openid = {
          ENABLE_OPENID_SIGNIN = false;
          ENABLE_OPENID_SIGNUP = false;
        };
        session.COOKIE_SECURE = true;
        oauth2_client = {
          ENABLE_AUTO_REGISTRATION = true;
          ACCOUNT_LINKING = "auto";
          USERNAME = "nickname";
          UPDATE_AVATAR = true;
        };
        "markup.sanitizer.TeX" = {
          ELEMENT = "span";
          ALLOW_ATTR = "class";
          REGEXP = ''^\\s*((math(\\s+|$)|inline(\\s+|$)|display(\\s+|$)))+$'';
        };
      };
    };

    # --- Systemd Overrides ---

    # Ensure the forgejo directory structure exists before any forgejo service starts.
    # forgejo-secrets.service uses ReadWritePaths=/var/lib/forgejo/custom which requires
    # the directory to exist for systemd mount namespace setup.
    systemd.services.forgejo-dir-setup = {
      description = "Create Forgejo directory structure";
      wantedBy = [ "multi-user.target" ];
      before = [ "forgejo-secrets.service" "forgejo.service" ];
      requiredBy = [ "forgejo-secrets.service" "forgejo.service" ];
      unitConfig.RequiresMountsFor = "/var/lib/forgejo";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs-default.coreutils}/bin/install -d -m 0750 -o ${cfg.serviceUsername} -g ${cfg.serviceGroup} /var/lib/forgejo
        ${pkgs-default.coreutils}/bin/install -d -m 0750 -o ${cfg.serviceUsername} -g ${cfg.serviceGroup} /var/lib/forgejo/custom
        ${pkgs-default.coreutils}/bin/install -d -m 0750 -o ${cfg.serviceUsername} -g ${cfg.serviceGroup} /var/lib/forgejo/custom/conf
      '';
    };

    systemd.services.forgejo = {
      unitConfig.RequiresMountsFor = "/var/lib/forgejo";
      after = [ "sops-nix.service" "postgresql.target" "forgejo-dir-setup.service" ];
      requires = [ "postgresql.target" ];
    };

    # --- OIDC Auth Source Setup ---

    systemd.services.forgejo-oidc-setup = {
      description = "Configure Forgejo OIDC auth source for Kanidm SSO";
      wantedBy = [ "multi-user.target" ];
      after = [ "forgejo.service" ];
      requires = [ "forgejo.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.serviceUsername;
        Group = cfg.serviceGroup;
        RemainAfterExit = true;
      };
      path = [ config.services.forgejo.package pkgs-default.gawk pkgs-default.gnugrep pkgs-default.coreutils ];
      script = let
        issuerUrl = "https://${ssoCfg.subdomain}.${config.server.webaddress}/oauth2/openid/${clientId}";
        discoveryUrl = "${issuerUrl}/.well-known/openid-configuration";
        ssoDisplayName = "Kanidm";
        forgejoWorkPath = "/var/lib/forgejo";
        forgejoCustomConf = "${forgejoWorkPath}/custom/conf/app.ini";
      in ''
        set -euo pipefail

        CLIENT_SECRET=$(cat "${config.sops.secrets."forgejo/clientSecret".path}")

        # Check if the auth source already exists
        EXISTING=$(forgejo --work-path ${forgejoWorkPath} --config ${forgejoCustomConf} admin auth list 2>&1 || true)

        if echo "$EXISTING" | grep -q "${ssoDisplayName}"; then
          echo "✅ OIDC auth source '${ssoDisplayName}' already exists, updating..."
          # Get the ID of the existing source
          SOURCE_ID=$(echo "$EXISTING" | grep "${ssoDisplayName}" | awk '{print $1}')
          forgejo --work-path ${forgejoWorkPath} --config ${forgejoCustomConf} admin auth update-oauth \
            --id="$SOURCE_ID" \
            --name="${ssoDisplayName}" \
            --provider="openidConnect" \
            --key="${clientId}" \
            --secret="$CLIENT_SECRET" \
            --auto-discover-url="${discoveryUrl}" \
            --scopes="openid email profile" \
            --skip-local-2fa \
            || true
          echo "✅ OIDC auth source updated"
        else
          echo "Creating OIDC auth source '${ssoDisplayName}'..."
          forgejo --work-path ${forgejoWorkPath} --config ${forgejoCustomConf} admin auth add-oauth \
            --name="${ssoDisplayName}" \
            --provider="openidConnect" \
            --key="${clientId}" \
            --secret="$CLIENT_SECRET" \
            --auto-discover-url="${discoveryUrl}" \
            --scopes="openid email profile" \
            --skip-local-2fa \
            || true
          echo "✅ OIDC auth source created"
        fi
      '';
    };

    # --- Reverse Proxy & SSO ---

    server.services = {
      reverseProxy.activeRedirects."forgejo" = lib.mkIf cfg.exposeGUI {
        subdomain = cfg.subdomain;
        useACMEHost = true;
        forceSSL = true;
        locations."/" = {
          path = "/";
          to = "http://[::1]:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 512M;
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
          '';
        };
      };

      singleSignOn.oAuthServices."${clientId}" = {
        displayName = "Forgejo";
        originUrl = [
          "https://${domain}/user/oauth2/Kanidm/callback"
          "https://${domain}/"
        ];
        originLanding = "https://${domain}";
        basicSecretFile = config.sops.secrets."forgejo/oauth/client_secret".path;
        preferShortUsername = true;
        groupName = "forgejo-users";
        scopes = [ "openid" "profile" "email" ];
      };
    };

    # --- DNS Loopback for SSO ---

    networking.extraHosts = ''
      127.0.0.1 ${domain}
    '';
  };
}
