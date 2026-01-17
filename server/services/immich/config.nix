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
        restartUnits = [ "immich.service" ];
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
        # Secrets
        IMMICH_OAUTH_CLIENT_SECRET="${config.sops.placeholder."immich/clientSecret"}"
        OAUTH_CLIENT_SECRET="${config.sops.placeholder."immich/clientSecret"}"
        DB_PASSWORD=nothing
        
        # OAuth Configuration
        IMMICH_OAUTH_ENABLED=true
        IMMICH_OAUTH_AUTO_REGISTER=true
        IMMICH_OAUTH_BUTTON_TEXT="Login with Kanidm"
        IMMICH_OAUTH_ISSUER_URL="https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/immich"
        IMMICH_OAUTH_CLIENT_ID="immich"
        IMMICH_OAUTH_SCOPE="openid email profile"
        IMMICH_OAUTH_STORAGE_LABEL_CLAIM="preferred_username"
        IMMICH_OAUTH_TOKEN_ENDPOINT_AUTH_METHOD="client_secret_basic"
        
        # ADD THIS LINE:
        IMMICH_OAUTH_SIGNING_ALGORITHM="ES256"

        # Log Level
        IMMICH_LOG_LEVEL="verbose"
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
          # clientSecret is provided via environment variable IMMICH_OAUTH_CLIENT_SECRET from secretsFile
          storageLabelClaim = "preferred_username";
          # CHANGE THIS LINE:
          tokenEndpointAuthMethod = "client_secret_basic"; 
        };
      };
      */

      environment = {
        # Allow self-signed certs (or loopback NAT issues) for the OIDC discovery handshake
        NODE_TLS_REJECT_UNAUTHORIZED = "0";
        IMMICH_LOG_LEVEL="verbose";
      };
      
    };

    # Ensure Immich waits for the IDP to be available before starting, 
    # otherwise OIDC discovery fails and OAuth is disabled.
    systemd.services.immich-server = {
      after = [ "kanidm.service" "nginx.service" ];
      wants = [ "kanidm.service" "nginx.service" ];
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
        basicSecretFile = config.sops.secrets."immich/oauth/client_secret".path;
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