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

    /*
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
          $KANIDM login -H "$KANIDM_URL" --name admin --password "$(cat "$ADMIN_PASS_FILE")" >/dev/null 2>&1
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
          $KANIDM login -H "$KANIDM_URL" --name admin --password "$(cat "$ADMIN_PASS_FILE")"
          exit 1
        fi

        echo "Kanidm is reachable. Authenticating and listing info..."
        $KANIDM system info -H "$KANIDM_URL" --name admin
      '';
    };
    */

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



    systemd.services.kanidm-ensure-declarativity = {
      description = "Kanidm ensure declarative configuration matches NixOS configuration";
      wantedBy = [ "multi-user.target" ];
      after = [ "kanidm.service" ];

      serviceConfig = {
        Type = "oneshot";
        User = "root"; # Root needed to stop/start services and read sops
      };

      path = with pkgs-default; [ gnugrep gawk systemd sudo ];

      script = ''
        # Set HOME to a temp directory to ensure clean session and no permission issues
        export HOME=$(mktemp -d)

        KANIDM_URL="https://${cfg.subdomain}.${config.server.webaddress}"
        ADMIN="idm_admin"
        SOPS_PASS_FILE="${config.sops.secrets."kanidm/oauth/client_secret".path}"
        KANIDM_BIN="${config.services.kanidm.package}/bin/kanidm"
        KANIDMD_BIN="${config.services.kanidm.package}/bin/kanidmd"

        echo "KANIDM_URL: $KANIDM_URL"
        echo "ADMIN: $ADMIN"
        echo "SOPS_PASS_FILE: $SOPS_PASS_FILE"
        echo "KANIDM_BIN: $KANIDM_BIN"
        echo "KANIDMD_BIN: $KANIDMD_BIN"

        echo "🏷️  Ensuring Kanidm service is running..."

        until systemctl is-active --quiet kanidm; do sleep 1; done

        echo "🔍 Checking if Admin password matches Sops secret..."

        if ! $KANIDM_BIN login -H "$KANIDM_URL" --name "$ADMIN" --password "$(cat "$SOPS_PASS_FILE")" >/dev/null 2>&1; then
          echo "X Error: Admin password does not match Sops secret. Aborting."
          exit 1
        fi

        echo "✅ Admin password matches Sops secret."

        echo "🔄 Applying declarative configuration to Kanidm..."

        # Setting image for OAuth clients
        echo "🔧 Setting OAuth client images..."
        $KANIDM_BIN system domain set-image ${../../sso.svg} -H "$KANIDM_URL" --name "$ADMIN"


        # Log out after operations
        $KANIDM_BIN logout -H "$KANIDM_URL" --name "$ADMIN"
        echo "✅ Declarative configuration applied successfully."
      '';
    };
  };
}