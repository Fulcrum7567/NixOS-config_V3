{ config, lib, pkgs-unstable, pkgs-default, currentHost, ... }:
let
  cfg = config.server.services.singleSignOn;
in
{
  config = lib.mkIf (config.server.services.singleSignOn.enable && (config.server.services.singleSignOn.activeConfig == "kanidm")) {
    
    server.services.singleSignOn.serviceUsername = "kanidm";
    server.services.singleSignOn.serviceGroup = "kanidm";


    systemd.tmpfiles.rules = [
      "d /data/kanidm 0700 ${cfg.serviceUsername} ${cfg.serviceGroup} -"
      "Z /data/kanidm 0700 ${cfg.serviceUsername} ${cfg.serviceGroup} -"
    ];

    fileSystems."/var/lib/kanidm" = {
      device = "/data/kanidm";
      options = [ "bind" ];
    };

    systemd.services.kanidm.unitConfig = {
      RequiresMountsFor = "/var/lib/kanidm";
    };

    sops.secrets = {
      "kanidm/adminPassword" = {
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
        adminPasswordFile = config.sops.secrets."kanidm/adminPassword".path;
        idmAdminPasswordFile = config.sops.secrets."kanidm/adminPassword".path;

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
      after = [ "kanidm.service" "sops-nix.service" ];

      serviceConfig = {
        Type = "oneshot";
        User = "root"; # Root needed to stop/start services and read sops
      };

      path = with pkgs-default; [ gnugrep gawk systemd sudo ];

      script = ''
        # Set HOME to a temp directory to ensure clean session and no permission issues
        export HOME=$(mktemp -d)

        KANIDM_URL="https://${cfg.subdomain}.${config.server.webaddress}"
        ADMIN="admin"
        SOPS_PASS_FILE="${config.sops.secrets."kanidm/adminPassword".path}"
        KANIDM_BIN="${config.services.kanidm.package}/bin/kanidm"
        KANIDMD_BIN="${config.services.kanidm.package}/bin/kanidmd"

        echo "KANIDM_URL: $KANIDM_URL"
        echo "ADMIN: $ADMIN"
        echo "SOPS_PASS_FILE: $SOPS_PASS_FILE"
        echo "KANIDM_BIN: $KANIDM_BIN"
        echo "KANIDMD_BIN: $KANIDMD_BIN"

        echo "🏷️  Ensuring Kanidm service is running..."

        until systemctl is-active --quiet kanidm; do sleep 1; done

        if ! $KANIDM_BIN login -H "$KANIDM_URL" --name "$ADMIN" --password "$(cat "$SOPS_PASS_FILE")"; then
          echo "Error: Admin password does not match Sops secret. Aborting."
          exit 1
        fi

        echo "✅ Admin password matches Sops secret."

        echo "🔄 Applying declarative configuration to Kanidm..."

        # Setting image for OAuth clients
        echo "🔧 Setting OAuth client images with this command:"
        echo "$KANIDM_BIN system domain set-image ${cfg.domainIcon} svg --url \"$KANIDM_URL\" --name \"$ADMIN\""
        $KANIDM_BIN system domain set-image ${cfg.domainIcon} svg --url "$KANIDM_URL" --name "$ADMIN"

        echo "🔧 Setting OAuth client display name with this command:"
        echo "$KANIDM_BIN system domain set-displayname \"${currentHost}\" --name \"$ADMIN\" --url \"$KANIDM_URL\""
        $KANIDM_BIN system domain set-displayname "${currentHost}" --name "$ADMIN" --url "$KANIDM_URL"


        # Log out after operations
        $KANIDM_BIN logout -H "$KANIDM_URL" --name "$ADMIN"
        echo "✅ Declarative configuration applied successfully."
      '';
    };
  };
}