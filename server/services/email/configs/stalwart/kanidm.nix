{ config, lib, ... }:
let
  stalwartTokenFile = "${config.services.stalwart-mail.dataDir}/kanidm_bind_token";
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

      "stalwart/oidc_secret" = {
        owner = "stalwart-mail";
        group = "stalwart-mail";
        sopsFile = ./stalwartSecrets.yaml;
        format = "yaml";
        key = "oidc_secret";
      };

      "kanidm/stalwart_oidc_secret" = {
        owner = config.server.services.singleSignOn.serviceUsername;
        group = config.server.services.singleSignOn.serviceGroup;
        sopsFile = ./stalwartSecrets.yaml;
        format = "yaml";
        key = "oidc_secret";
      };
    };

    server.services.singleSignOn.oAuthServices."stalwart" = {
      displayName = "Stalwart Mail";
      originUrl = [ "https://${config.server.services.email.fullDomainName}/auth/oidc" ];
      originLanding = "https://${config.server.services.email.fullDomainName}";
      basicSecretFile = config.sops.secrets."kanidm/stalwart_oidc_secret".path;
      groupName = "stalwart_users";
      scopes = [ "openid" "profile" "email" ];
    };
    
    services.stalwart-mail.settings = {
      directory."kanidm" = {
        type = "ldap";
        url = "ldaps://${config.server.services.singleSignOn.fullDomainName}:636";
        base-dn = "dc=kanidm,dc=local";

        bind = {
          dn = "dn=token"; # Adjust based on Kanidm config
          secret = "%{file:${stalwartTokenFile}}%";
        };

        # LDAP Mapping
        # Kanidm uses standard attributes usually, but double check your schema
        map = {
          name = "cn";       # Kanidm display name
          email = "mail";    # Kanidm email attribute
          secret = "userPassword";
        };

        # Authentication Mode
        # Kanidm does not expose cleartext passwords. Stalwart must 
        # send the credentials to Kanidm to verify (Bind Auth).
        auth = {
          method = "bind";
        };

        # Default query for finding users
        search = {
          filter = "(&(objectClass=person)(mail=%{email}))";
        };
      };

      storage.directory = "kanidm";

      authentication.oidc = {
        method = "oidc";
        client-id = "stalwart";
        client-secret = "%{file:${config.sops.secrets."stalwart/oidc_secret".path}}%";
        issuer = "https://${config.server.services.singleSignOn.fullDomainName}/oauth2/openid/stalwart";
        scopes = [ "openid" "profile" "email" ];
        redirect-url = "https://${config.server.services.email.fullDomainName}/auth/oidc";
        directory = "kanidm";
      };
    };


    server.services.singleSignOn.kanidm.extraIterativeIdmSteps = ''
      # --- Stalwart Service Account & Token Provisioning ---
      
      STALWART_USER="stalwart"
      MANAGED_BY="idm_admin"
      TOKEN_FILE="${stalwartTokenFile}"
      
      # 1. Create the account if it doesn't exist
      if ! $KANIDM_BIN service-account get "$STALWART_USER" --url "$KANIDM_URL" --name "$IDM_ADMIN" >/dev/null 2>&1; then
        echo "Creating Stalwart service account..."
        $KANIDM_BIN service-account create "$STALWART_USER" "Stalwart Mail" "$MANAGED_BY" --url "$KANIDM_URL" --name "$IDM_ADMIN"
      fi

      # 2. Provision the Token (Stateful Check)
      # We only generate a token if the file doesn't exist on disk.
      if [ ! -f "$TOKEN_FILE" ]; then
        echo "Generating new API Token for Stalwart..."
        
        # We ask Kanidm for a new token. 
        # CAUTION: Output format parsing. We assume the token is the last line or specific format.
        # Kanidm usually outputs: "Token: <ActualToken>"
        
        RAW_OUTPUT=$($KANIDM_BIN service-account api-token generate --name "$MANAGED_BY" "$STALWART_USER" "stalwart-ldap-bind" --url "$KANIDM_URL")
        
        # Extract the token (simple awk to get the last word if format is "Token: XXXXX")
        # Adjust this parsing if your kanidm version output differs.
        TOKEN=$(echo "$RAW_OUTPUT" | tail -n 1 | tr -d '[:space:]')
        
        if [ -n "$TOKEN" ]; then
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
        fi
      else
        # Ensure permissions are correct even if file exists
        chown stalwart-mail:stalwart-mail "$TOKEN_FILE"
        chmod 600 "$TOKEN_FILE"
      fi
    '';
  };
}