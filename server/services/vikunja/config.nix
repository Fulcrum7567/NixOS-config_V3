{ config, lib, pkgs-default, pkgs, ... }:
let 
  cfg = config.server.services.vikunja;

  domain = "${cfg.subdomain}.${config.server.webaddress}";
  clientId = "vikunja";
  
  # Generate YAML config with the secret placeholder
  vikunjaConfig = pkgs.formats.yaml { };
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

    # Generate complete config file with secret via sops template
    sops.templates."vikunja-config.yaml" = {
      # Make readable by Vikunja's dynamic user
      mode = "0444";
      restartUnits = [ "vikunja.service" ];
      content = ''
        database:
          type: sqlite
          path: ${cfg.defaultDataDir}/vikunja.db
        files:
          basepath: ${cfg.defaultDataDir}/files
        service:
          interface: ":${toString cfg.port}"
          frontendurl: "https://${domain}/"
          publicurl: "https://${domain}/"
          timezone: "${cfg.timezone}"
        auth:
          local:
            enabled: false
          openid:
            enabled: true
            # Auto-redirect to Kanidm when login is required
            redirecturl: "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/${clientId}"
            providers:
              - name: "kanidm"
                authurl: "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/${clientId}"
                logouturl: "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/ui/logout"
                clientid: "${clientId}"
                clientsecret: "${config.sops.placeholder."vikunja/oauth/client_secret"}"
                scope: "openid profile email"
      '';
    };

    services.vikunja = {
      enable = true;
      port = cfg.port; 
      frontendScheme = "https";
      frontendHostname = domain;
    };
    
    # Override the config file location to use our sops-generated config
    environment.etc."vikunja/config.yaml".source = lib.mkForce config.sops.templates."vikunja-config.yaml".path;

    # Make sure data folder exists with correct permissions
    systemd.tmpfiles.rules = [
      "d ${cfg.defaultDataDir} 0770 root root - -"
      "d ${cfg.defaultDataDir}/files 0770 root root - -"
    ];

    # Ensure Vikunja can write to the data directory
    systemd.services.vikunja.serviceConfig = {
      ReadWritePaths = [ cfg.defaultDataDir ];
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
        # Vikunja 0.24.x doesn't support PKCE, so we need to disable it
        allowInsecureClientDisablePkce = true;
      };
    };
    
  };
}