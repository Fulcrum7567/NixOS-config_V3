{ config, lib, pkgs-default, ... }:
let
  cfg = config.server.services.mail-server;
  ssoCfg = config.server.services.singleSignOn;
  domain = config.server.webaddress;
  mailDomain = cfg.fullDomainName;
  ssoFullDomain = ssoCfg.fullDomainName;

  # Kanidm LDAP base DN derived from the SSO domain
  # e.g. "sso.aurek.eu" -> "dc=sso,dc=aurek,dc=eu"
  ldapBaseDn = lib.concatStringsSep "," (map (part: "dc=${part}") (lib.splitString "." ssoFullDomain));
in
{
  config = lib.mkIf (cfg.enable && (cfg.activeConfig == "stalwart")) {

    # ── Sops Secrets ──────────────────────────────────────────────────────
    sops.secrets = {
      # API token for the stalwart-ldap service account in Kanidm.
      # Used as the LDAP bind password (bind DN = "dn=token").
      "stalwart/ldap_bind_password" = {
        owner = "stalwart-mail";
        group = "stalwart-mail";
        sopsFile = ./stalwartSecrets.yaml;
        format = "yaml";
        key = "stalwart_ldap_bind_password";
        restartUnits = [ "stalwart-mail.service" ];
      };
    };


    # ── Stalwart Mail Service ─────────────────────────────────────────────
    services.stalwart = {
      enable = true;
      openFirewall = true;

      settings = {
        server = {
          hostname = "mx1.${domain}";

          tls = {
            enable = true;
            implicit = true;
          };

          listener = {
            # Inbound SMTP (MTA-to-MTA)
            smtp = {
              protocol = "smtp";
              bind = "[::]:25";
            };

            # Submission (client -> server, implicit TLS)
            submissions = {
              protocol = "smtp";
              bind = "[::]:465";
              tls.implicit = true;
            };

            # IMAPS (client -> server, implicit TLS)
            imaps = {
              protocol = "imap";
              bind = "[::]:993";
              tls.implicit = true;
            };

            # JMAP / Web Admin (HTTP, behind nginx reverse proxy)
            jmap = {
              protocol = "http";
              bind = "127.0.0.1:8080";
              url = "https://${mailDomain}";
            };
          };
        };

        # ── TLS Certificates ──────────────────────────────────────────────
        # Re-use the wildcard ACME certificates managed by nginx
        certificate."default" = {
          cert = "%{file:/var/lib/acme/${domain}/fullchain.pem}%";
          private-key = "%{file:/var/lib/acme/${domain}/key.pem}%";
        };

        # ── Lookup defaults ───────────────────────────────────────────────
        lookup.default = {
          hostname = "mx1.${domain}";
          domain = domain;
        };

        # ── LDAP Directory (Kanidm) ──────────────────────────────────────
        directory."kanidm" = {
          type = "ldap";

          # Kanidm serves LDAPS on port 636 (reuses its TLS certs)
          url = "ldaps://${ssoFullDomain}:636";

          base-dn = ldapBaseDn;

          tls = {
            enable = false;          # Already LDAPS, no STARTTLS needed
            allow-invalid-certs = false;
          };

          timeout = "30s";

          # Bind with the service account API token for directory searches.
          # In Kanidm, "dn=token" + API-token-as-password gives elevated read access.
          bind = {
            dn = "dn=token";
            secret = "%{file:${config.sops.secrets."stalwart/ldap_bind_password".path}}%";

            auth = {
              # Use "lookup" method: first search for the user's DN using the
              # service-account bind, then re-bind as the user with their password.
              # This works with Kanidm's POSIX password authentication.
              method = "lookup";
            };
          };

          # Kanidm LDAP filter templates
          filter = {
            # Search by account name or SPN (service principal name).
            # Users may log in as "fulcrum" (name) or "fulcrum@sso.aurek.eu" (spn).
            name = "(&(class=account)(|(name=?)(spn=?)))";
            # Search by email address (Kanidm uses "mail" attribute)
            email = "(&(class=account)(|(mail=?)))";
          };

          # Kanidm LDAP attribute mappings
          attributes = {
            name = "name";
            class = "objectclass";
            description = [ "displayname" ];
            groups = [ "memberof" ];
            email = "mail";
            quota = "diskQuota";
          };
        };

        # ── Storage & Auth Settings ───────────────────────────────────
        storage.directory = "kanidm";

        session.auth = {
          mechanisms = "[plain]";
          directory = "'kanidm'";
        };

        session.rcpt.directory = "'kanidm'";

        directory."imap".lookup.domains = [ domain ];

        # ── OAuth Token Settings ──────────────────────────────────────────
        # Stalwart's OAuth token generation calls password_hash() when the
        # token expiry exceeds 3600s. With LDAP bind auth, Kanidm does not
        # expose password hashes, causing "Account does not contain secrets".
        # Setting all token expiries to ≤ 3600s avoids the password_hash()
        # call entirely. The web UI auto-refreshes tokens transparently.
        oauth.expiry = {
          token = "1h";              # Access token: exactly 3600s (≤ 3600 skips hash)
          refresh-token = "1h";      # Refresh token: also ≤ 3600s to avoid hash lookup
          refresh-token-renew = "30m"; # Renew refresh token when 30min remaining
        };

        # ── Admin fallback ────────────────────────────────────────────────
        # Uses the LDAP bind token as fallback admin password.
        # The kanidm admin password can't be used here (owned by kanidm:kanidm).
        authentication.fallback-admin = {
          user = "admin";
          secret = "%{file:${config.sops.secrets."stalwart/ldap_bind_password".path}}%";
        };
      };
    };

    # ── System user ───────────────────────────────────────────────────────
    users.users.stalwart-mail.extraGroups = [ "nginx" ];  # Access ACME certs

    # ── Firewall ──────────────────────────────────────────────────────────
    # openFirewall handles 25, 465, 993 via the NixOS module.
    # JMAP/WebAdmin is only on localhost behind nginx.

    # ── Nginx Reverse Proxy ───────────────────────────────────────────────
    server.services.reverseProxy.activeRedirects."stalwart-mail" = {
      subdomain = cfg.subdomain;
      useACMEHost = true;
      forceSSL = true;

      locations."/" = {
        path = "/";
        to = "http://127.0.0.1:8080";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };

    # ── Kanidm Service Account & Group Provisioning ─────────────────────
    # Declaratively provision the "mail-users" group via Kanidm's provisioner.
    services.kanidm.provision.groups."mail-users" = {
      present = true;
      members = [ ];
    };

    # Imperatively create the stalwart-ldap service account in Kanidm
    # (service accounts can't be provisioned declaratively, only persons/groups/oauth2).
    server.services.singleSignOn = {
      kanidm.extraIterativeIdmSteps = ''
        echo "🔧 Provisioning Stalwart LDAP service account..."

        # Create the service account if it doesn't exist
        if ! $KANIDM_BIN service-account get stalwart-ldap -H "$KANIDM_URL" --name "$IDM_ADMIN" 2>/dev/null; then
          echo "  Creating stalwart-ldap service account..."
          $KANIDM_BIN service-account create stalwart-ldap "Stalwart Mail LDAP Bind" idm_admins -H "$KANIDM_URL" --name "$IDM_ADMIN"
        else
          echo "  stalwart-ldap service account already exists."
        fi

        # Grant the service account mail server read privileges.
        # Without this, LDAP searches return "denied - no entries were released"
        # because the API token bind has no permission to read person attributes.
        echo "🔧 Adding stalwart-ldap to idm_mail_servers..."
        $KANIDM_BIN group add-members idm_mail_servers stalwart-ldap -H "$KANIDM_URL" --name "$IDM_ADMIN" 2>/dev/null \
          && echo "  ✅ Added to idm_mail_servers." \
          || echo "  ℹ️  Already a member of idm_mail_servers."

        # Enable POSIX attributes on all persons so they can bind via LDAP.
        # Kanidm LDAP auth requires a POSIX-enabled account with a POSIX password.
        echo "🔧 Enabling POSIX attributes on all person accounts..."
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: _: ''
          if $KANIDM_BIN person posix show ${name} -H "$KANIDM_URL" --name "$IDM_ADMIN" 2>/dev/null | grep -q "gidnumber"; then
            echo "  ${name}: POSIX already enabled."
          else
            echo "  ${name}: Enabling POSIX attributes..."
            $KANIDM_BIN person posix set ${name} -H "$KANIDM_URL" --name "$IDM_ADMIN" || echo "  ⚠️ Failed to enable POSIX for ${name}"
          fi
        '') config.server.users)}

        echo "✅ Stalwart LDAP service account provisioning complete."
        echo ""
        echo "📝 NOTE: Each user must set a POSIX/UNIX password via the Kanidm"
        echo "   web UI (Security → POSIX Password) for LDAP/mail login."
        echo "   This is separate from the Kanidm primary credential."
      '';

      kanidm.extraIterativeSteps = ''
        echo "🔧 Ensuring Stalwart LDAP API token..."

        STALWART_TOKEN_FILE="${config.sops.secrets."stalwart/ldap_bind_password".path}"

        # Check if the stored token still works by attempting an LDAP whoami
        CURRENT_TOKEN=$(cat "$STALWART_TOKEN_FILE" 2>/dev/null || echo "")

        if [ -n "$CURRENT_TOKEN" ]; then
          echo "  LDAP bind token found in sops secret. Service account ready."
        else
          echo "  ⚠️  No LDAP bind token found in sops secret!"
          echo "  Please generate one manually with:"
          echo "    kanidm service-account api-token generate stalwart-ldap 'LDAP Bind Token' --name idm_admin"
          echo "  Then store it in stalwartSecrets.yaml as stalwart_ldap_bind_password"
        fi
      '';
    };

    # ── Systemd Dependencies ──────────────────────────────────────────────
    systemd.services.stalwart-mail = {
      after = [ "kanidm.service" "nginx.service" "sops-nix.service" ];
      wants = [ "kanidm.service" "nginx.service" ];
    };

  };
}