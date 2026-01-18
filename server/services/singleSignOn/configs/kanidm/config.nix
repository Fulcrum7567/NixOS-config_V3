{ config, lib, pkgs-unstable, pkgs-default, ... }:
let
  cfg = config.server.services.singleSignOn;
in
{
  config = lib.mkIf (config.server.services.singleSignOn.enable && (config.server.services.singleSignOn.activeConfig == "kanidm")) {
    
    server.services.singleSignOn.serviceUsername = "kanidm";
    server.services.singleSignOn.serviceGroup = "kanidm";

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
      package = pkgs-unstable.kanidmWithSecretProvisioning_1_8;
      serverSettings = {
        domain = cfg.subdomain + "." + config.server.webaddress;
        origin = "https://${cfg.subdomain}.${config.server.webaddress}";
        bindaddress = "127.0.0.1:${toString cfg.port}";
        # Kanidm requires TLS internally usually, but if behind local reverse proxy
        # strictly on localhost, you can sometimes run http. 
        # However, standard practice is to let Kanidm manage its certs or point to existing ones.
        # For this example, we assume you might be using ACME certs or self-signed for localhost.
        # If using ACME from Nginx, Kanidm needs access to those certs.
        tls_chain = "/var/lib/acme/${config.server.webaddress}/fullchain.pem";
        tls_key = "/var/lib/acme/${config.server.webaddress}/key.pem";
      };

      provision = {
        enable = true;
        # This file is used to authenticate the provisioner against the server
        idmAdminPasswordFile = config.sops.secrets."kanidm/oauth/client_secret".path;

        persons = {
          "${config.user.settings.username}" = {
            displayName = config.user.settings.displayName;
            legalName = config.user.settings.displayName;
            mailAddresses = [ "dragon.fighter@outlook.de" ];
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
          imageFile = service.imageFile;
          preferShortUsername = service.preferShortUsername;
          scopeMaps = {
            "${service.groupName}" = service.scopes;
          };
        }) cfg.oAuthServices;

      };
    };

    systemd.services.kanidm-declarative-options = {
      description = "Kanidm declarative database options";
      after = [ "kanidm.service" "nginx.service" "kanidm-provision.service" ];
      wants = [ "kanidm.service" "nginx.service" "kanidm-provision.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.serviceUsername;
        Group = cfg.serviceGroup;
      };
      script = ''
        # Helper variables
        KANIDM="${config.services.kanidm.package}/bin/kanidm"
        KANIDM_URL="https://${cfg.subdomain}.${config.server.webaddress}"
        ADMIN_PASS_FILE="${config.sops.secrets."kanidm/oauth/client_secret".path}"
        
        # Kanidm needs a writable HOME for session config
        export HOME=$(mktemp -d)

        # Function to check connectivity
        check_status() {
          tr -d '\n' < cat "$ADMIN_PASS_FILE" | $KANIDM login -H "$KANIDM_URL" --name admin >/dev/null 2>&1
        }

        echo "Waiting for Kanidm to be ready at $KANIDM_URL..."
        
        # Retry loop
        MAX_RETRIES=30
        COUNT=0
        until check_status || [ $COUNT -eq $MAX_RETRIES ]; do
          echo "Kanidm not reachable yet... ($COUNT/$MAX_RETRIES)"
          sleep 2
          COUNT=$((COUNT+1))
        done

        if [ $COUNT -eq $MAX_RETRIES ]; then
          echo "Failed to connect to Kanidm after $MAX_RETRIES attempts."
          echo "Last error:"
          tr -d '\n' < "$ADMIN_PASS_FILE" | $KANIDM login -H "$KANIDM_URL" --name admin
          exit 1
        fi

        echo "Kanidm is reachable. Authenticating and listing info..."
        $KANIDM system info -H "$KANIDM_URL" --name admin
      '';
    };

    users.users.${cfg.serviceUsername}.extraGroups = [ "nginx" ];

    server.services = {
      reverseProxy.activeRedirects."kanidm-sso" = {
        subdomain = cfg.subdomain;
        useACMEHost = true;
        forceSSL = true;

        locations."/" = {
          path = "/";
          to = "https://127.0.0.1:${toString cfg.port}";
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
  };
}