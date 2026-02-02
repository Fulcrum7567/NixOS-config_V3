{ config, lib, pkgs-default, ... }:
let 
  cfg = config.server.services.vikunja;

  domain = "${cfg.subdomain}.${config.server.webaddress}";
  clientId = "vikunja";
in 
{
  config = lib.mkIf cfg.enable {

    sops.secrets = {
      "vikunja/oauth/client_secret" = {
        owner = config.server.services.singleSignOn.serviceUsername;
        group = config.server.services.singleSignOn.serviceGroup;
        sopsFile = ./vikunjaSecrets.yaml;
        format = "yaml";
        key = "vikunja_client_secret";
        restartUnits = [ "kanidm.service" ];
        mode = "0440";
      };

      # Secret instance for Vikunja Service
      "vikunja/clientSecret" = {
        owner = cfg.serviceUsername;
        group = cfg.serviceGroup;
        sopsFile = ./vikunjaSecrets.yaml;
        format = "yaml";
        key = "vikunja_client_secret";
        restartUnits = [ "vikunja.service" ];
      };
    };

    sops.templates."vikunja-config.yml" = {
      owner = cfg.serviceUsername;
      group = cfg.serviceGroup;
      restartUnits = [ "vikunja.service" ];
      content = builtins.toJSON {
        service = {
          # Critical for OIDC redirects
          publicurl = "https://${domain}/";
          timezone = cfg.timezone;
        };
        auth.openid = {
          enabled = true;
          providers = [
            {
              name = "kanidm"; # This name appears on the login button
              # Kanidm OIDC Discovery URL
              authurl = "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/${clientId}";
              clientid = clientId;
              # Sops-Nix replaces this placeholder with the actual secret string
              clientsecret = config.sops.placeholder."vikunja/clientSecret";
            }
          ];
        };
      };
    };


    services.vikunja = {
      enable = true;
      # We rely on the sops template for configuration to handle the secret
      environment = {
        # Force Vikunja to use our sops-generated config file
        VIKUNJA_CONFIG_FILE = lib.mkForce config.sops.templates."vikunja-config.yml".path;
        # Alternatively, depending on version, it might look for VIKUNJA_SERVICE_CONFIGFILE
        VIKUNJA_SERVICE_CONFIGFILE = lib.mkForce config.sops.templates."vikunja-config.yml".path;
      };
      # Bind to localhost so nginx can proxy it
      port = cfg.port; 
      frontendScheme = "https";
      frontendHostname = domain;
    };

    /*
    
    # Make sure folder exists with correct permissions
    systemd.tmpfiles.rules = [
      "d ${config.server.services.immich.defaultDataDir} 0770 ${config.services.immich.user} ${config.services.immich.group} - -"
      "Z ${config.server.services.immich.defaultDataDir} 0770 ${config.services.immich.user} ${config.services.immich.group} - -"
    ];
    */

    

    server.services = {
      reverseProxy.activeRedirects."vikunja" = {
        subdomain = cfg.subdomain;
        useACMEHost = true;
        forceSSL = true;

        locations."/" = {
          path = "/";
          to = "http://[::1]:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 5000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        }; 
      };

      singleSignOn.oAuthServices."${clientId}" = {
        displayName = "Vikunja";
        # Vikunja redirect URL format: <publicurl>/auth/openid/<provider-name>
        originUrl = [ "https://${domain}/auth/openid/kanidm" ]; 
        originLanding = "https://${domain}";
        # This points Kanidm to the SAME secret file Vikunja is reading
        basicSecretFile = config.sops.secrets."vikunja/oauth/client_secret".path;
        preferShortUsername = true;
        # Ensure you have a suitable icon or remove this line
        # imageFile = ./vikunja.svg; 
        groupName = "vikunja_users";
        scopes = [ "openid" "profile" "email" ];
      };
    };
    
  };
}