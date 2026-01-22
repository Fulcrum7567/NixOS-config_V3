{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.email.enable && (config.server.services.email.activeConfig == "stalwart") && 
  (config.server.services.singleSignOn.enable && (config.server.services.singleSignOn.activeConfig == "kanidm"))) {

    sops.secrets = {
      "stalwart/kanidm_bind_password" = {
        owner = "stalwart-mail";
        group = "stalwart-mail";
        sopsFile = ./stalwartSecrets.yaml;
        format = "yaml";
        key = "kanidm_link";
      };
    };
    
    services.stalwart-mail.settings = {
      directory.kanidm = {
        type = "ldap";
        address = "ldaps://${config.server.services.singleSignOn.fullDomainName}:636";

        bind = {
          dn = "name=stalwart,cn=services,dc=kanidm,dc=local"; # Adjust based on Kanidm config
          secret = "%{file:${config.sops.secrets."stalwart/kanidm_bind_password".path}}%";
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
          base = "dc=kanidm,dc=local"; # Adjust to your Kanidm domain
          filter = "(&(objectClass=person)(mail=%{email}))";
        };
      };

      storage.directory = "kanidm";
    };


    server.services.singleSignOn.kanidm.extraIterativeIdmSteps = ''
        # --- Stalwart Service Account Provisioning ---
        
        STALWART_USER="stalwart"
        # Path to the secret provided by sops-nix
        SECRET_FILE="${config.sops.secrets."stalwart/kanidm_bind_password".path}"
        MANAGED_BY="admin"
        
        # 1. Create the account if it doesn't exist
        # We suppress output to keep logs clean, checking exit code
        if ! $KANIDM_BIN service-account get "$STALWART_USER" --url "$KANIDM_URL" --name "$ADMIN" >/dev/null 2>&1; then
          echo "Creating Stalwart service account..."
          $KANIDM_BIN service-account create "$STALWART_USER" "Stalwart Mail" "$MANAGED_BY" --url "$KANIDM_URL" --name "$ADMIN"
        fi

        # 2. Sync the password
        # We always update the password to match what is in the sops secret.
        # This ensures that if you rotate the secret in sops, Kanidm gets updated automatically.
        if [ -f "$SECRET_FILE" ]; then
          cat "$SECRET_FILE" | $KANIDM_BIN service-account credential update-password "$STALWART_USER" --url "$KANIDM_URL" --name "$ADMIN"
        else
          echo "WARNING: Stalwart secret file not found at $SECRET_FILE"
        fi

        # 3. (Optional) Permissions
        # By default, a service account can read public info (which is usually enough 
        # for Stalwart to find users). If Stalwart logs errors about permissions,
        # you might need to add the account to a group with read claims, 
        # but standard LDAP bind/search usually works out of the box.
      '';
  };
}