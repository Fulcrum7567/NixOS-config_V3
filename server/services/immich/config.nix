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

    sops.templates."immich.json" = {
      owner = config.services.immich.user;
      group = config.services.immich.group;
      restartUnits = [ "immich-server.service" ];
      
      # We define the settings here in Nix, and convert to JSON automatically.
      # This keeps it clean but allows us to inject the secret placeholder.
      content = builtins.toJSON {
        oauth = {
          enabled = true;
          autoRegister = true;
          buttonText = "Login with Kanidm";
          issuerUrl = "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/immich";
          clientId = "immich";
          autoLaunch = true;
          
          
          # The placeholder is a string, so toJSON handles it perfectly.
          # SOPS-Nix will replace this string with the actual password in the final file.
          clientSecret = config.sops.placeholder."immich/clientSecret";
          
          scope = "openid email profile";
          storageLabelClaim = "preferred_username";
          tokenEndpointAuthMethod = "client_secret_post";
          signingAlgorithm = "ES256";
        };
        server = {
          externalDomain = "https://immich.${config.server.webaddress}";
        };
      };
    };

    
    services.immich = {
      enable = true;
      user = "immich";
      group = lib.mkIf (config.services.immich.user == config.user.settings.username) "users";
      mediaLocation = config.server.services.immich.defaultDataDir;
      port = config.server.services.immich.port;
      accelerationDevices = null;

      environment = {
        # Force Immich to use our sops-generated config file
        IMMICH_CONFIG_FILE = lib.mkForce config.sops.templates."immich.json".path;
        
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
        originUrl = [ "https://immich.${config.server.webaddress}/auth/login" "https://immich.${config.server.webaddress}/user-settings" "app.immich:///oauth-callback"];
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