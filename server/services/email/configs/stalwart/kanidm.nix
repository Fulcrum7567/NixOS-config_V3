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
            dn = "name=stalwart-ldap"; # Adjust based on Kanidm config
            secret = "%{file:${stalwartTokenFile}}%";
          };
          
          # Construct Base DN from domain (e.g. aurek.eu -> dc=aurek,dc=eu)
          base-dn = builtins.concatStringsSep "," (map (s: "dc=${s}") (lib.splitString "." config.server.webaddress));

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
          url = "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/stalwart-mail"; 
          client-id = "stalwart-mail";
          client-secret = "%{file:${config.sops.secrets."stalwart/clientSecret".path}}%";
          
          # Use userinfo endpoint to fetch claims (standard for OIDC directories)
          endpoint.method = "userinfo"; 

          # Kanidm certificates might be self-signed or internal
          tls = {
             enable = true;
             allow-invalid-certs = true;
          };

          # Map OIDC claims to Stalwart attributes
          map = {
            name = "name";
            email = "email";
            username = "preferred_username";
          };
        };
      };

      client-auth = "client_secret_post";

      # Allow users to be automatically created when they login
      session.auth.auto-create = true;

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
        STALWART_USER="stalwart-ldap"
        TOKEN_FILE="${stalwartTokenFile}"

        # 2. Provision the Token
        # We only generate a token if the file doesn't exist on disk.
        
        # Helper check: If service account is missing but token exists, force token regeneration
        # This handles cases where account was deleted but file remained.
        if ! $KANIDM_BIN service-account get "$STALWART_USER" -H "$KANIDM_URL" --name "$IDM_ADMIN" --password "$(cat "$SOPS_PASS_FILE")" >/dev/null 2>&1; then
           if [ -f "$TOKEN_FILE" ]; then
             echo "Updating state: Service account missing but token file exists. Validating..."
             # We assume token is invalid if account is gone.
             rm "$TOKEN_FILE"
           fi
        fi
        if [ ! -f "$TOKEN_FILE" ]; then
          echo "Token file missing. Setting up service account and token..."

          # If the account exists, we MUST delete it to ensure a fresh state compatible with API tokens.
          # We execute delete and ignore failures (e.g. if it doesn't exist) to keep it idempotent.
          $KANIDM_BIN service-account delete "$STALWART_USER" -H "$KANIDM_URL" --name "$IDM_ADMIN" --password "$(cat "$SOPS_PASS_FILE")" >/dev/null 2>&1 || true

          echo "Creating $STALWART_USER service account..."
          # Create standard service account (supports API tokens)
          # Usage: service-account create <account_id> <display_name> <managed_by>
          $KANIDM_BIN service-account create "$STALWART_USER" "Stalwart Mail" "$IDM_ADMIN" \
            -H "$KANIDM_URL" --name "$IDM_ADMIN" --password "$(cat "$SOPS_PASS_FILE")"

          echo "Generating new API Token for Stalwart..."
          RAW_OUTPUT=$($KANIDM_BIN service-account api-token generate --name "$IDM_ADMIN" --password "$(cat "$SOPS_PASS_FILE")" -H "$KANIDM_URL" "$STALWART_USER" "stalwart-ldap-bind")
          
          # Extract the token (taking the last word of the output)
          TOKEN=$(echo "$RAW_OUTPUT" | awk '{print $NF}')
          
          if [ -n "$TOKEN" ] && [[ "$TOKEN" != *"Error"* ]]; then
            # Ensure the directory exists
            mkdir -p $(dirname "$TOKEN_FILE")
            
            # Write to file
            echo -n "$TOKEN" > "$TOKEN_FILE"
            
            # Secure the file (Stalwart needs to read it)
            chown stalwart-mail:stalwart-mail "$TOKEN_FILE"
            chmod 600 "$TOKEN_FILE"
            
            echo "✅ Token generated and saved to $TOKEN_FILE"
          else
            echo "❌ Failed to extract token from Kanidm output."
            echo "Raw output: $RAW_OUTPUT"
            exit 1
          fi
        else
          # Ensure permissions are correct even if file exists
          if [ -f "$TOKEN_FILE" ]; then
            chown stalwart-mail:stalwart-mail "$TOKEN_FILE"
            chmod 600 "$TOKEN_FILE"
          fi
        fi
      '';

      oAuthServices."stalwart-mail" = {
        displayName = "Stalwart Mail";
        originUrl = [ "https://${config.server.services.email.fullDomainName}/auth/oidc" ]; 
        originLanding = "https://${config.server.services.email.fullDomainName}";
        basicSecretFile = config.sops.secrets."stalwart/oauth/clientSecret".path;
        preferShortUsername = true; 
        groupName = "stalwart-users"; 
        scopes = [ "openid" "profile" "email" ];
      };

    };
  };
}