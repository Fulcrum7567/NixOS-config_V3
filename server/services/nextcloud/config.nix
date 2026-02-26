{ config, lib, pkgs-default, ... }:
let 
  cfg = config.server.services.nextcloud;
  domain = "${cfg.subdomain}.${config.server.webaddress}";
  clientId = "nextcloud";
in 
{
  config = lib.mkIf cfg.enable {

    # ── SOPS Secrets ──────────────────────────────────────────────
    sops.secrets = {
      # Secret shared between Kanidm and Nextcloud for OAuth
      "nextcloud/oauth/client_secret" = {
        owner = config.server.services.singleSignOn.serviceUsername;
        group = config.server.services.singleSignOn.serviceGroup;
        sopsFile = ./nextcloudSecrets.yaml;
        format = "yaml";
        key = "nextcloud_client_secret";
        restartUnits = [ "kanidm.service" ];
        mode = "0440";
      };

      "nextcloud/clientSecret" = {
        owner = "nextcloud";
        group = "nextcloud";
        sopsFile = ./nextcloudSecrets.yaml;
        format = "yaml";
        key = "nextcloud_client_secret";
        restartUnits = [ "phpfpm-nextcloud.service" ];
      };

      "nextcloud/adminPassword" = {
        owner = "nextcloud";
        group = "nextcloud";
        sopsFile = ./nextcloudSecrets.yaml;
        format = "yaml";
        key = "nextcloud_admin_password";
      };
    };


    # ── Nextcloud Service ─────────────────────────────────────────
    services.nextcloud = {
      enable = true;
      package = pkgs-default.nextcloud32;
      hostName = domain;
      https = true;
      datadir = cfg.defaultDataDir;
      maxUploadSize = "50G";
      
      configureRedis = true;

      config = {
        adminuser = cfg.adminUsername;
        adminpassFile = config.sops.secrets."nextcloud/adminPassword".path;
        dbtype = "pgsql";
      };

      database.createLocally = true;

      settings = {
        overwriteprotocol = "https";
        default_phone_region = "DE";
        log_type = "file";
        loglevel = 2;
        maintenance_window_start = 3; # 3 AM UTC

        # Disable local login to force SSO via Kanidm
        # Users authenticate exclusively through Kanidm with passkeys
        hide_login_form = true;

        # Allow Kanidm-authenticated users to be auto-provisioned
        allow_user_to_change_display_name = false;
      };

      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
          contacts calendar tasks notes;
      };

      # Install the OIDC Login app for Kanidm integration
      extraApps.oidc_login = pkgs-default.fetchNextcloudApp {
        url = "https://github.com/pulsejet/nextcloud-oidc-login/releases/download/v3.3.0/oidc_login.tar.gz";
        sha256 = "sha256-AU938duXaI625chqgnnqnvOB0bMgRM3ZQVilstb4yRI=";
        license = "agpl3Plus";
      };
    };


    # ── OIDC Login Configuration (via Nextcloud settings) ─────────
    # The oidc_login app reads its config from Nextcloud's config.php.
    # We inject it via services.nextcloud.settings which merges into config.php.
    services.nextcloud.settings = {
      # OIDC Login app configuration
      oidc_login_provider_url = "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/${clientId}";
      oidc_login_client_id = clientId;
      oidc_login_client_secret._secret = config.sops.secrets."nextcloud/clientSecret".path;
      oidc_login_auto_redirect = true;
      oidc_login_end_session_redirect = false;
      oidc_login_logout_url = "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/ui/logout";
      oidc_login_button_text = "Login with Kanidm";
      oidc_login_hide_password_form = true;
      oidc_login_use_id_token = false;
      oidc_login_scope = "openid profile email";
      oidc_login_disable_registration = false;
      oidc_login_redir_fallback = false;
      oidc_login_tls_verify = true;

      # Attribute mapping: map Kanidm claims to Nextcloud user attributes
      oidc_login_attributes = {
        id = "preferred_username";
        name = "name";
        mail = "email";
      };

      oidc_login_code_challenge_method = "S256";

      # Use the token endpoint auth method that Kanidm expects
      oidc_login_token_auth_method = "client_secret_post";
    };


    # ── Data Directory & Permissions ──────────────────────────────
    systemd.tmpfiles.rules = [
      "d ${cfg.defaultDataDir} 0750 nextcloud nextcloud - -"
      "Z ${cfg.defaultDataDir} 0750 nextcloud nextcloud - -"
    ];


    # ── Reverse Proxy ─────────────────────────────────────────────
    # Nextcloud on NixOS uses its own nginx virtualhost by default.
    # We configure the custom reverse proxy abstraction to point to it.
    server.services = {
      reverseProxy.activeRedirects."nextcloud" = lib.mkIf cfg.exposeGUI {
        subdomain = cfg.subdomain;
        useACMEHost = true;
        forceSSL = true;

        locations."/" = {
          path = "/";
          to = "http://[::1]:80";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50G;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            proxy_set_header     X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header     X-Forwarded-Proto $scheme;
            proxy_set_header     Host $host;
          '';
        };
      };

      # ── SSO / Kanidm OAuth Registration ───────────────────────────
      singleSignOn.oAuthServices."${clientId}" = {
        displayName = "Nextcloud";
        originUrl = [
          "https://${domain}/apps/oidc_login/oidc"
          "https://${domain}/"
        ];
        originLanding = "https://${domain}";
        basicSecretFile = config.sops.secrets."nextcloud/oauth/client_secret".path;
        preferShortUsername = true;
        imageFile = ./nextcloud.svg;
        groupName = "nextcloud-users";
        scopes = [ "openid" "profile" "email" ];
      };
    };

    # Nextcloud's built-in nginx config listens on port 80 by default.
    # Ensure it uses the correct hostname for ACME/SSL via our reverse proxy.
    services.nginx.virtualHosts.${domain} = {
      listen = [{ addr = "[::1]"; port = 80; }];
      forceSSL = lib.mkForce false;
    };
  };
}