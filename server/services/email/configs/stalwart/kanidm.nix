{ config, lib, ... }:
let
  stalwartTokenFile = "${config.services.stalwart-mail.dataDir}/kanidm_bind_token_v2";
in
{
  config = lib.mkIf (config.server.services.email.enable && (config.server.services.email.activeConfig == "stalwart") && 
  (config.server.services.singleSignOn.enable && (config.server.services.singleSignOn.activeConfig == "kanidm"))) {

    systemd.services.stalwart-mail = {
      requires = [ "kanidm-ensure-declarativity.service" ];
      after = [ "kanidm-ensure-declarativity.service" ];
    };

    sops.secrets = {
      "stalwart/kanidm_bind_password" = {
        owner = "stalwart-mail";
        group = "stalwart-mail";
        sopsFile = ./stalwartSecrets.yaml;
        format = "yaml";
        key = "kanidm_link";
      };

      "stalwart/clientSecret" = {
        owner = "stalwart-mail";
        group = "stalwart-mail";
        sopsFile = ./stalwartSecrets.yaml;
        format = "yaml";
        key = "stalwart_client_secret";
      };

      "stalwart/oauth/clientSecret" = {
        owner = config.server.services.singleSignOn.serviceUsername;
        group = config.server.services.singleSignOn.serviceGroup;
        sopsFile = ./stalwartSecrets.yaml;
        format = "yaml";
        key = "stalwart_client_secret";
      };
    };
    
    services.stalwart-mail.settings = {
      directory = {
        "kanidm-ldap" = {
          type = "ldap";
          url = "ldaps://${config.server.services.singleSignOn.fullDomainName}:636";
          timeout = "5s";

          tls = {
            enable = true;
            allow-invalid-certs = true;
          };

          bind = {
            dn = "name=stalwart"; # Adjust based on Kanidm config
            secret = "%{file:${config.sops.secrets."stalwart/kanidm_bind_password".path}}%";
          };

          # LDAP Mapping
          # Kanidm uses standard attributes usually, but double check your schema
          map = {
            name = "name";       # Kanidm display name
            email = "mail";    # Kanidm email attribute
            # Secret removed to force Bind authentication, as Kanidm does not expose password hashes
          };
        };

        "kanidm-oidc" = {
          type = "oidc";
          url = "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/stalwart"; 
          client-id = "stalwart";
          client-secret = "%{file:${config.sops.secrets."stalwart/clientSecret".path}}%";
          
          # Map OIDC claims to Stalwart attributes
          map = {
            name = "name";
            email = "email";
            username = "preferred_username";
          };
        };
      };

      authentication.fallback-ldap = {
        directory = "kanidm-ldap";
      };

      authentication.oidc = {
        directory = "kanidm-oidc"; 
      };

      storage.directory = "kanidm-ldap";
    };


    server.services.singleSignOn = {
      kanidm.extraIterativeIdmSteps = lib.mkAfter ''
        if ! $KANIDM_BIN service-account get "stalwart" -H "$KANIDM_URL" --name "$IDM_ADMIN" --password "$(cat "$SOPS_PASS_FILE")" >/dev/null 2>&1; then
          echo "Creating stalwart service account..."
          $KANIDM_BIN service-account create "stalwart" "Stalwart Mail" \
            --proto service-account-creds \
            -H "$KANIDM_URL" --name "$IDM_ADMIN" --password "$(cat "$SOPS_PASS_FILE")"
        fi

        STALWART_PW_FILE="${config.sops.secrets."stalwart/kanidm_bind_password".path}"
        
        if [ -f "$STALWART_PW_FILE" ]; then
           echo "Updating stalwart service account password..."
           cat "$STALWART_PW_FILE" | $KANIDM_BIN service-account credential update "stalwart" \
             --proto service-account-credentials \
             -H "$KANIDM_URL" --name "$IDM_ADMIN" --password "$(cat "$SOPS_PASS_FILE")"
        else
           echo "Warning: Stalwart bind password file not found at $STALWART_PW_FILE"
        fi
      '';

      oAuthServices."stalwart" = {
        displayName = "Stalwart Mail";
        originUrl = [ "https://${config.server.services.email.fullDomainName}/auth/oidc" ]; 
        originLanding = "https://${config.server.services.email.fullDomainName}";
        basicSecretFile = config.sops.secrets."stalwart/oauth/clientSecret".path;
        preferShortUsername = true; 
        groupName = "stalwart-users"; 
        scopes = [ "openid" "profile" "email" ];
        extraconfig = ''
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };

    };
  };
}