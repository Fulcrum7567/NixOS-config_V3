{ config, lib, ... }:
let
  cfg = config.server.services.email;
  ssoCfg = config.server.services.singleSignOn;
  stalwartDomain = cfg.subdomain + "." + config.server.webaddress;
in
{
  config = lib.mkIf (cfg.enable && (cfg.activeConfig == "stalwart")) {

    # --- Sops Secrets ---
    sops.secrets = {
      # LDAP bind password for Stalwart to query Kanidm's LDAP interface
      "stalwart/ldap/bind_password" = {
        owner = config.services.stalwart-mail.user or "stalwart-mail";
        group = config.services.stalwart-mail.group or "stalwart-mail";
        sopsFile = ./stalwartSecrets.yaml;
        format = "yaml";
        key = "stalwart_ldap_bind_password";
        restartUnits = [ "stalwart-mail.service" ];
      };

      # Service account password for Kanidm LDAP bind (used by kanidm to set it up)
      "stalwart/kanidm/service_password" = {
        owner = ssoCfg.serviceUsername;
        group = ssoCfg.serviceGroup;
        sopsFile = ./stalwartSecrets.yaml;
        format = "yaml";
        key = "stalwart_ldap_bind_password";
        restartUnits = [ "kanidm.service" ];
        mode = "0440";
      };
    };

    # --- Stalwart Mail Service ---
    services.stalwart-mail = {
      enable = true;
      settings = {
        # -- Server / Listener config --
        server = {
          hostname = stalwartDomain;
          
          listener = {
            # SMTP (MTA - receiving mail from other servers)
            smtp = {
              bind = [ "[::]:25" ];
              protocol = "smtp";
            };

            # SMTP Submission (authenticated users sending mail)
            submission = {
              bind = [ "[::]:587" ];
              protocol = "smtp";
              tls.implicit = false; # STARTTLS
            };

            # SMTP Submissions (implicit TLS)
            submissions = {
              bind = [ "[::]:465" ];
              protocol = "smtp";
              tls.implicit = true;
            };

            # IMAP
            imap = {
              bind = [ "[::]:143" ];
              protocol = "imap";
              tls.implicit = false; # STARTTLS
            };

            # IMAPS (implicit TLS)
            imaps = {
              bind = [ "[::]:993" ];
              protocol = "imap";
              tls.implicit = true;
            };

            # HTTP (management API / webadmin, behind reverse proxy)
            http = {
              bind = [ "127.0.0.1:${toString cfg.port}" "[::1]:${toString cfg.port}" ];
              protocol = "http";
            };
          };
        };

        # -- Authentication directory: Kanidm via LDAP --
        # Kanidm exposes an LDAP interface on port 636 (LDAPS) by default.
        # Stalwart will bind as a service account and use LDAP bind auth
        # (lookup method) since Kanidm doesn't expose password hashes.
        directory."kanidm-ldap" = {
          type = "ldap";
          url = "ldaps://${ssoCfg.subdomain}.${config.server.webaddress}";
          base-dn = "dc=${lib.concatStringsSep ",dc=" (lib.splitString "." config.server.webaddress)}";
          timeout = "15s";

          tls = {
            enable = true;
            allow-invalid-certs = true; # Set to false in production with valid certs
          };

          # Default bind credentials - service account for searching
          bind = {
            dn = "dn=service_account,dc=${lib.concatStringsSep ",dc=" (lib.splitString "." config.server.webaddress)}";
            secret = "%{file:${config.sops.secrets."stalwart/ldap/bind_password".path}}%";
          };

          # Use bind authentication with lookup since Kanidm
          # does not expose password hashes via LDAP
          bind.auth = {
            method = "lookup";
          };

          # LDAP search filters
          filter = {
            name = "(&(objectClass=person)(name=?))";
            email = "(&(objectClass=person)(|(mail=?)(mailAlias=?)))";
          };

          # Map Kanidm LDAP attributes to Stalwart attributes
          attributes = {
            name = "name";
            class = "objectClass";
            description = "displayname";
            groups = "memberOf";
            email = "mail";
            email-alias = "mailAlias";
            quota = "quota";
            secret-changed = "modifytimestamp";
          };
        };

        # -- Storage configuration --
        storage = {
          data = "rocksdb";
          fts = "rocksdb";
          blob = "rocksdb";
          lookup = "rocksdb";
          directory = "kanidm-ldap";
        };

        store."rocksdb" = {
          type = "rocksdb";
          path = "${cfg.defaultDataDir}/db";
        };

        # -- Authentication settings --
        authentication.fallback-admin = {
          user = "admin";
          # You should change this or use a secret; this is just for initial setup
          secret = "%{file:${config.sops.secrets."stalwart/ldap/bind_password".path}}%";
        };

        # -- TLS certificate (use ACME certs from nginx) --
        certificate."default" = {
          cert = "%{file:/var/lib/acme/${config.server.webaddress}/cert.pem}%";
          private-key = "%{file:/var/lib/acme/${config.server.webaddress}/key.pem}%";
        };
      };
    };

    # -- Ensure stalwart can read ACME certs --
    users.users.${config.services.stalwart-mail.user or "stalwart-mail"}.extraGroups = [ "acme" ];

    # -- Ensure data directory exists --
    systemd.tmpfiles.rules = [
      "d ${cfg.defaultDataDir} 0750 ${config.services.stalwart-mail.user or "stalwart-mail"} ${config.services.stalwart-mail.group or "stalwart-mail"} - -"
      "d ${cfg.defaultDataDir}/db 0750 ${config.services.stalwart-mail.user or "stalwart-mail"} ${config.services.stalwart-mail.group or "stalwart-mail"} - -"
    ];

    # -- Systemd ordering --
    systemd.services.stalwart-mail = {
      after = [ "kanidm.service" "network-online.target" ];
      wants = [ "kanidm.service" ];
    };

    # -- Reverse Proxy (webadmin / API) --
    server.services = {
      reverseProxy.activeRedirects."mail" = lib.mkIf (cfg.exposeGUI or false) {
        subdomain = cfg.subdomain;
        useACMEHost = true;
        forceSSL = true;

        locations."/" = {
          path = "/";
          to = "http://[::1]:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50M;
          '';
        };
      };

      # Register a Kanidm service account for LDAP bind
      # This uses your existing SSO abstraction to create the service account
      # that Stalwart will use for LDAP searches
      singleSignOn.ldapServices."stalwart" = {
        displayName = "Stalwart Mail";
        basicSecretFile = config.sops.secrets."stalwart/kanidm/service_password".path;
        groupName = "mail-users";
      };
    };

    # -- DNS: open mail-related ports in firewall --
    networking.firewall.allowedTCPPorts = [
      25    # SMTP
      465   # SMTPS
      587   # Submission
      143   # IMAP
      993   # IMAPS
    ];
  };
}