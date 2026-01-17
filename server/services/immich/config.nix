{ config, lib, pkgs-default, ... }:
{
  config = lib.mkIf config.server.services.immich.enable {

    sops.secrets = {
      "immich/oauth/client_secret" = {
        owner = config.server.services.singleSignOn.serviceUsername;
        group = config.server.services.singleSignOn.serviceGroup;
        sopsFile = ./immichSecrets.yaml;
        format = "yaml";
        key = "immich_client_secret";
        restartUnits = [ "kanidm.service" ];
        mode = "0440";
      };

      "immich/clientSecret" = {
        owner = config.services.immich.user;
        group = config.services.immich.group;
        sopsFile = ./immichSecrets.yaml;
        format = "yaml";
        key = "immich_client_secret";
        restartUnits = [ "immich-server.service" ];
      };
    };

    sops.templates."immich.env" = {
      content = ''
        # Secrets (Keep this!)
        IMMICH_OAUTH_CLIENT_SECRET="${config.sops.placeholder."immich/clientSecret"}"
        OAUTH_CLIENT_SECRET="${config.sops.placeholder."immich/clientSecret"}"
        
        # Log Level
        IMMICH_LOG_LEVEL="verbose"
        
        # REMOVE all the other IMMICH_OAUTH_* lines you added previously.
        # They are ignored by Immich and are now handled by 'settings' above.
      '';
      owner = config.services.immich.user;
      group = config.services.immich.group;
      restartUnits = [ "immich-server.service" ];
    };

    sops.templates."immich.json" = {
      content = ''
        {
          "oauth": {
            "enabled": true,
            "autoRegister": true,
            "buttonText": "Login with Kanidm",
            "issuerUrl": "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/immich",
            "clientId": "immich",
            "scope": "openid email profile",
            "storageLabelClaim": "preferred_username",
            "tokenEndpointAuthMethod": "client_secret_post",
            "signingAlgorithm": "ES256"
          },
          "server": {
            "externalDomain": "https://immich.${config.server.webaddress}"
          }
        }
      '';
      owner = config.services.immich.user;
      group = config.services.immich.group;
      restartUnits = [ "immich-server.service" ];
    };
    
    services.immich = {
      enable = true;
      user = "immich";
      group = lib.mkIf (config.services.immich.user == config.user.settings.username) "users";
      mediaLocation = config.server.services.immich.defaultDataDir;

      port = config.server.services.immich.port;

      accelerationDevices = null;

      secretsFile = config.sops.templates."immich.env".path;

      /*
      settings = {
        oauth = {
          enabled = true;
          autoRegister = true;
          buttonText = "Login with Kanidm";
          issuerUrl = "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/immich";
          clientId = "immich";
          scope = "openid email profile";
          # The secret is loaded from the environment variable automatically
          storageLabelClaim = "preferred_username";
          tokenEndpointAuthMethod = "client_secret_basic";
          
          # ADD THIS LINE TO FIX THE ERROR:
          signingAlgorithm = "ES256";
        };
      };
      */

      environment = {
        # 2. NEW: Tells Immich to load OAuth settings from the JSON file
        IMMICH_CONFIG_FILE = "/run/immich-config/config.json";
        
        # Keep other env vars
        IMMICH_LOG_LEVEL = "verbose";
        NODE_TLS_REJECT_UNAUTHORIZED = "0";
      };
      
    };

    # Ensure Immich waits for the IDP to be available before starting, 
    # otherwise OIDC discovery fails and OAuth is disabled.
    systemd.services.immich-server = {
      after = [ "kanidm.service" "nginx.service" ];
      wants = [ "kanidm.service" "nginx.service" ];
    };

    # Service to strip newline from sops secret for Kanidm AND generate Immich config
    systemd.services.prepare-immich-secrets = {
      description = "Prepare secrets and config for Immich and Kanidm";
      requiredBy = [ "kanidm.service" "immich-server.service" ];
      before = [ "kanidm.service" "immich-server.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        RuntimeDirectory = "immich-config"; # Creates /run/immich-config
      };
      script = ''
        # 1. Clean secret for Kanidm
        mkdir -p /run/kanidm-secrets
        if [ -f "${config.sops.secrets."immich/oauth/client_secret".path}" ]; then
          # Strip newline
          tr -d '\n' < "${config.sops.secrets."immich/oauth/client_secret".path}" > /run/kanidm-secrets/immich_client_secret_clean
          
          # Set permissions for Kanidm
          chown ${config.server.services.singleSignOn.serviceUsername}:${config.server.services.singleSignOn.serviceGroup} /run/kanidm-secrets/immich_client_secret_clean
          chmod 440 /run/kanidm-secrets/immich_client_secret_clean

          # 2. Generate config for Immich
          # Copy template to runtime dir
          cp "${config.sops.templates."immich.json".path}" /run/immich-config/config.json
          chmod 600 /run/immich-config/config.json
          
          # Inject secret using jq
          SECRET=$(cat /run/kanidm-secrets/immich_client_secret_clean)
          ${pkgs-default.jq}/bin/jq --arg s "$SECRET" '.oauth.clientSecret = $s' /run/immich-config/config.json > /run/immich-config/config.json.tmp && mv /run/immich-config/config.json.tmp /run/immich-config/config.json
          
          # Set permissions for Immich
          chown ${config.services.immich.user}:${config.services.immich.group} /run/immich-config/config.json
          chmod 440 /run/immich-config/config.json
        fi
      '';
    };

    users.users.${config.services.immich.user}.extraGroups = [ "video" "render" ];

    
    # Make sure folder exists with correct permissions
    systemd.tmpfiles.rules = [
      "d ${config.server.services.immich.defaultDataDir} 0770 ${config.services.immich.user} ${config.services.immich.group} - -"
      "Z ${config.server.services.immich.defaultDataDir} 0770 ${config.services.immich.user} ${config.services.immich.group} - -"
    ];

    

    server.services = {
      reverseProxy.activeRedirects."immich" = lib.mkIf config.server.services.immich.exposeGUI {
        subdomain = "immich";
        useACMEHost = true;
        forceSSL = true;

        locations."/" = {
          path = "/";
          to = "http://[::1]:${toString config.services.immich.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50G;
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
          '';
        };
      };

      singleSignOn.oAuthServices."immich" = {
        displayName = "Immich";
        originUrl = [ "https://immich.${config.server.webaddress}/auth/login" "app.immich:///oauth-callback"];
        originLanding = "https://immich.${config.server.webaddress}";
        basicSecretFile = "/run/kanidm-secrets/immich_client_secret_clean";
        preferShortUsername = true;
        groupName = "immich-users";
        scopes = [ "openid" "profile" "email" ];
      };
    };

    # Ensure Immich can reach Kanidm locally for OIDC discovery
    networking.extraHosts = ''
      127.0.0.1 ${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}
    '';
  };
}