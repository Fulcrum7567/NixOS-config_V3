{ config, lib, pkgs-default, ... }:
let 
  cfg = config.server.services.vikunja;

  domain = "${cfg.subdomain}.${config.server.webaddress}";
  clientId = "vikunja";

  # Generate plain config file (no secrets needed for public OAuth2 client)
  vikunjaConfigFile = pkgs-default.writeText "vikunja-config.yaml" ''
    database:
      type: sqlite
      path: /var/lib/vikunja/vikunja.db
    files:
      basepath: /var/lib/vikunja/files
    service:
      interface: ":${toString cfg.port}"
      frontendurl: "https://${domain}/?redirectToProvider=true"
      publicurl: "https://${domain}/"
      timezone: "${cfg.timezone}"
    auth:
      local:
        enabled: false
      openid:
        enabled: true
        providers:
          kanidm:
            name: "kanidm"
            authurl: "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/${clientId}"
            logouturl: "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/ui/logout"
            clientid: "${clientId}"
            scope: "openid profile email"
  '';
in 
{
  config = lib.mkIf cfg.enable {

    # Create a static user for vikunja (instead of DynamicUser)
    users.users.${cfg.serviceUsername} = {
      isSystemUser = true;
      group = cfg.serviceGroup;
      home = "/var/lib/vikunja";
    };
    users.groups.${cfg.serviceGroup} = { };

    # Create the data directory and bind mount it to /var/lib/vikunja
    systemd.tmpfiles.rules = [
      "d ${cfg.defaultDataDir} 0750 ${cfg.serviceUsername} ${cfg.serviceGroup} - -"
      "Z ${cfg.defaultDataDir} 0750 ${cfg.serviceUsername} ${cfg.serviceGroup} - -"
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

    # Override systemd service to use static user instead of DynamicUser
    systemd.services.vikunja = {
      unitConfig.RequiresMountsFor = "/var/lib/vikunja";
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = cfg.serviceUsername;
        Group = cfg.serviceGroup;
      };
    };
    
    # Override the config file location to use our generated config
    environment.etc."vikunja/config.yaml".source = lib.mkForce vikunjaConfigFile;

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
        originUrl = [ 
          "https://${domain}/auth/openid/kanidm" 
          "https://${domain}/"
        ]; 
        originLanding = "https://${domain}";
        imageFile = ./checklist.png; 
        preferShortUsername = true;
        groupName = "vikunja_users";
        scopes = [ "openid" "profile" "email" ];
        # Public client: no secret, PKCE enforced — required for native/mobile app localhost redirects
        public = true;
        enableLocalhostRedirects = true;
      };
    };
    
  };
}