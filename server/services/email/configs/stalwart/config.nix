{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.email.enable && (config.server.services.email.activeConfig == "stalwart")) {
    
    sops.secrets = {
      "stalwart/admin_password" = {
        owner = "stalwart-mail";
        group = "stalwart-mail";
        sopsFile = ./stalwartSecrets.yaml;
        format = "yaml";
        key = "admin_password";
      };
    };

    users.users.stalwart-mail.extraGroups = [ "nginx" ];

    services.stalwart-mail = {
      enable = true;
      
      dataDir = "${config.server.system.filesystem.defaultDataDir}/stalwart-mail";
      # Stalwart Settings (Reference: https://stalw.art/docs/config)
      settings = {
        config.local-keys = [
          "store.*"
          "directory.*"
          "tracer.*"
          "!server.blocked-ip.*"
          "!server.allowed-ip.*"
          "server.*"
          "authentication.fallback-admin.*"
          "cluster.*"
          "config.local-keys.*"
          "storage.data"
          "storage.blob"
          "storage.lookup"
          "storage.fts"
          "storage.directory"
          "certificate.*"
          "resolver.*"
          "spam-filter.*"
          "webadmin.*"
        ];
        server = {
          hostname = config.server.services.email.fullDomainName;
          tls = {
            enable = true;
            implicit = true; # Enforce TLS
          };
        };

        authentication.fallback-admin = {
          user = "admin";
          secret = "%{file:${config.sops.secrets."stalwart/admin_password".path}}%";
        };

        certificate.default = {
          cert = "%{file:/var/lib/acme/${config.server.webaddress}/fullchain.pem}%";
          private-key = "%{file:/var/lib/acme/${config.server.webaddress}/key.pem}%";
        };
      };
    };

    server.services = {
      reverseProxy.activeRedirects."stalwart" = {
        subdomain = "${config.server.services.email.subdomain}";
        useACMEHost = true;
        forceSSL = true;

        locations."/" = {
          path = "/";
          to = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        }; 
      };
    };


    networking.firewall.allowedTCPPorts = [ 
      25   # SMTP
      465  # SMTP Submission (TLS)
      587  # SMTP Submission (STARTTLS)
      993  # IMAP (TLS)
      4190 # Sieve
    ];
  };
    
}