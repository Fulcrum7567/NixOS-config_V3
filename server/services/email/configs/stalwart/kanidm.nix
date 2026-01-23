{ config, lib, ... }:
let
  cfg = config.server.services.singleSignOn;
  emailCfg = config.server.services.email;
  kanidmDomain = "${cfg.subdomain}.${config.server.webaddress}";
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
      # LDAP Directory configuration for Kanidm
      directory."kanidm" = {
        type = "ldap";
        url = "ldaps://${kanidmDomain}:636";
        base-dn = "dc=${lib.concatStringsSep ",dc=" (lib.splitString "." kanidmDomain)}";
        timeout = "30s";
        
        tls = {
          enable = true;
          allow-invalid-certs = false;
        };

        bind = {
          # Bind DN for the stalwart service account (created in Kanidm)
          dn = "dn=token";
          secret = "%{file:${config.sops.secrets."stalwart/kanidm_bind_password".path}}%";
          
          auth = {
            # Use lookup method to find the user DN and then bind as the user
            method = "lookup";
          };
        };

        filter = {
          name = "(&(|(objectClass=person)(objectClass=account))(name=?))";
          email = "(&(|(objectClass=person)(objectClass=account))(|(mail=?)))";
        };

        attributes = {
          name = "name";
          class = "objectClass";
          description = "displayname";
          email = "mail";
          groups = "memberof";
          quota = "quota";
        };
      };

      # OIDC Directory configuration for OAuth/web login
      directory."kanidm-oidc" = {
        type = "oidc";
        timeout = "5s";
        endpoint = {
          url = "https://${kanidmDomain}/oauth2/openid/stalwart/userinfo";
          method = "userinfo";
        };
        fields = {
          email = "email";
          username = "preferred_username";
          full-name = "name";
        };
      };

      # Use Kanidm LDAP as the primary directory for authentication
      storage.directory = "kanidm";

      # Enable auto-creation of accounts on first login
      session.auth.auto-create = true;

      # OAuth/OIDC configuration for web interface login
      authentication.oidc."kanidm" = {
        display-name = "Login with Kanidm";
        issuer-url = "https://${kanidmDomain}/oauth2/openid/stalwart";
        client-id = "stalwart";
        client-secret = "%{file:${config.sops.secrets."stalwart/clientSecret".path}}%";
        scopes = [ "openid" "profile" "email" ];
        directory = "kanidm-oidc";
      };
    };

    # Register Stalwart as an OAuth client in Kanidm
    server.services.singleSignOn.oAuthServices."stalwart" = {
      displayName = "Stalwart Mail";
      originUrl = [ 
        "${emailCfg.fullHttpsUrl}/authorize/code" 
      ];
      originLanding = "${emailCfg.fullHttpsUrl}";
      basicSecretFile = config.sops.secrets."stalwart/oauth/clientSecret".path;
      preferShortUsername = true;
      groupName = "mail-users";
      scopes = [ "openid" "profile" "email" ];
    };
  };
}