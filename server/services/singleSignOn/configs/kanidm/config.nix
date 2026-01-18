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

    systemd.services.kanidm-enforce-policy = {
      description = "Enforce Kanidm Account Policies";
      after = [ "kanidm.service" ];
      wants = [ "kanidm.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "kanidm";  # Must match the 'owner' of your sops secret
        Group = "kanidm";
      };
      script = ''
        # --- Configuration ---
        KANIDM_URL="https://127.0.0.1:8443"
        ADMIN_USER="admin"
        
        # Nix automatically inserts the correct path to your sops secret here
        PASS_FILE="${config.sops.secrets."kanidm/oauth/client_secret".path}"

        # --- Pre-flight Checks ---
        if [ ! -f "$PASS_FILE" ]; then
          echo "⚠️  Secret file not found at $PASS_FILE. Skipping."
          exit 0
        fi

        # Wait for Kanidm to be responsive
        until ${config.services.kanidm.package}/bin/kanidmd healthcheck; do
          echo "Waiting for Kanidm..."
          sleep 2
        done

        # --- Authentication ---
        # Log in using the password from the sops secret
        cat "$PASS_FILE" | ${config.services.kanidm.package}/bin/kanidm login \
          --url "$KANIDM_URL" \
          --name "$ADMIN_USER" \
          --force

        # --- Apply Policy ---
        echo "Enforcing 4-hour session limit on idm_all_persons..."
        ${config.services.kanidm.package}/bin/kanidm group account-policy auth-expiry idm_all_persons 14400 \
          --url "$KANIDM_URL" \
          --name "$ADMIN_USER"
      '';
    };
  };
}