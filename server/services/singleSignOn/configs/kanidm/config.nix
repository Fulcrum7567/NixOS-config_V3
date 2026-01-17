{ config, lib, ... }:
let
  cfg = config.server.services.singleSignOn;
in
{
  config = lib.mkIf (config.server.services.singleSignOn.enable && (config.server.services.singleSignOn.activeConfig == "kanidm")) {
    
    cfg.serviceUsername = "kanidm";
    cfg.serviceGroup = "kanidm";

    sops.secrets = {
      # Kanidm OAuth client secret
      "kanidm/oauth/client_secret" = {
        owner = cfg.serviceUsername;
        group = cfg.serviceGroup;
        sopsFile = ./kanidmSecrets.yaml;
        format = "yaml";
        key = "kanidm_admin_password";
        restartUnits = [ "kanidm.service" ];
      };
    };

    services.kanidm = {
      enableServer = true;
      serverSettings = {
        domain = cfg.subdomain + "." + config.host.settings.domain;
        origin = "https://${cfg.subdomain}.${config.host.settings.domain}";
        bindaddress = "[::1]:${toString cfg.port}";
        # Kanidm requires TLS internally usually, but if behind local reverse proxy
        # strictly on localhost, you can sometimes run http. 
        # However, standard practice is to let Kanidm manage its certs or point to existing ones.
        # For this example, we assume you might be using ACME certs or self-signed for localhost.
        # If using ACME from Nginx, Kanidm needs access to those certs.
        tls_chain = "/var/lib/acme/${config.host.settings.domain}/fullchain.pem";
        tls_key = "/var/lib/acme/${config.host.settings.domain}/key.pem";
      };

      provision = {
        enable = true;
        # This file is used to authenticate the provisioner against the server
        idmAdminPasswordFile = config.sops.secrets."kanidm/oauth/client_secret".path;

        persons = {
          "${config.user.settings.username}" = {
            displayName = config.user.settings.displayName;
            legalName = config.user.settings.displayName;
            mailAddresses = [];
            present = true;
          };
        };

        groups = lib.listToAttrs (map (service: {
          name = service.groupName;
          value = {
            present = true;
            members = [ config.user.settings.username ];
          };
        }) (lib.attrValues cfg.oAuthServices));

        systems.oauth2 = lib.mapAttrs (name: service: {
          displayName = service.displayName;
          originUrl = service.originUrl;
          originLanding = service.originLanding;
          basicSecretFile = service.basicSecretFile;
          preferShortUsername = service.preferShortUsername;
          scopeMaps = {
            "${service.groupName}" = service.scopes;
          };
        }) cfg.oAuthServices;

      };
    };

    users.users.${cfg.serviceUsername}.extraGroups = [ "nginx" ];

    server.services = {
      reverseProxy.activeRedirects."kanidm-sso" = {
        subdomain = cfg.subdomain;
        useACMEHost = true;
        forceSSL = true;

        locations."/" = {
          path = "/";
          to = "http://[::1]:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_ssl_verify off; # Since Kanidm might use self-signed certs internally
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };    
  };
}