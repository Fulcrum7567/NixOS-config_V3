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
          path: /var/lib/vikunja/vikunja.db
        files:
          basepath: /var/lib/vikunja/files
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
            providers:
              - name: "kanidm"
                authurl: "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/${clientId}"
                logouturl: "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/ui/logout"
                clientid: "${clientId}"
                clientsecret: "${config.sops.placeholder."vikunja/oauth/client_secret"}"
                scope: "openid profile email"
      '';
    };

    # Create the data directory and bind mount it to /var/lib/vikunja
    # This allows the DynamicUser to access it while storing data in our backup location
    systemd.tmpfiles.rules = [
      "d ${cfg.defaultDataDir} 0700 root root - -"
    ];

    fileSystems."/var/lib/vikunja" = {
      device = cfg.defaultDataDir;
      options = [ "bind" ];
    };

    services.vikunja = {
      enable = true;
      port = cfg.port; 
      frontendScheme = "https";
      frontendHostname = domain;
    };

    systemd.services.vikunja.unitConfig = {
      RequiresMountsFor = "/var/lib/vikunja";
    };
    
    # Override the config file location to use our sops-generated config
    environment.etc."vikunja/config.yaml".source = lib.mkForce config.sops.templates."vikunja-config.yaml".path;

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
        imageFile = ./checklist.png; 
        groupName = "vikunja_users";
        scopes = [ "openid" "profile" "email" ];
        # Vikunja 0.24.x doesn't support PKCE, so we need to disable it
        allowInsecureClientDisablePkce = true;
      };
    };
    
  };
}