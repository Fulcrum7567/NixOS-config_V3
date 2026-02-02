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
    };

    # Environment file for the client secret
    # Vikunja reads VIKUNJA_AUTH_OPENID_PROVIDERS_0_CLIENTSECRET from environment
    sops.templates."vikunja.env" = {
      restartUnits = [ "vikunja.service" ];
      content = ''
        VIKUNJA_AUTH_OPENID_PROVIDERS_0_CLIENTSECRET=${config.sops.placeholder."vikunja/oauth/client_secret"}
      '';
    };

    services.vikunja = {
      enable = true;
      port = cfg.port; 
      frontendScheme = "https";
      frontendHostname = domain;
      
      # Pass the secret via environment file
      environmentFiles = [ config.sops.templates."vikunja.env".path ];
      
      # Configure Vikunja settings properly via NixOS module
      settings = {
        service = {
          publicurl = "https://${domain}/";
          timezone = cfg.timezone;
        };
        auth = {
          local = {
            enabled = false; # Disable local auth to force SSO
          };
          openid = {
            enabled = true;
            providers = [
              {
                name = "kanidm"; # This name appears on the login button and is used in redirect URL
                # Kanidm OIDC Discovery URL (issuer URL)
                authurl = "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/${clientId}";
                logouturl = "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/ui/logout";
                clientid = clientId;
                # clientsecret is injected via environmentFiles above
                scope = "openid profile email";
              }
            ];
          };
        };
      };
    };

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
        # Also include the base URL for token refresh scenarios
        originUrl = [ 
          "https://${domain}/auth/openid/kanidm" 
          "https://${domain}/"
        ]; 
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