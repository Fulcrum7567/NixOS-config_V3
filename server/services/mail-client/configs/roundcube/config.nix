{ config, lib, ... }:
let
  cfg = config.server.services.mail-client;
  mailServerCfg = config.server.services.mail-server;
  ssoCfg = config.server.services.singleSignOn;
  domain = config.server.webaddress;
in
{
  config = lib.mkIf (cfg.enable && (cfg.activeConfig == "roundcube")) {

    # ── Sops Secrets ──────────────────────────────────────────────────────
    # Secret for Kanidm provisioning (owned by kanidm user)
    sops.secrets."roundcube/oauth/client_secret" = {
      owner = ssoCfg.serviceUsername;
      group = ssoCfg.serviceGroup;
      sopsFile = ./roundcubeSecrets.yaml;
      format = "yaml";
      key = "roundcube_client_secret";
      restartUnits = [ "kanidm.service" ];
      mode = "0440";
    };

    # Secret for Roundcube itself (readable by the roundcube user)
    sops.secrets."roundcube/clientSecret" = {
      owner = "roundcube";
      group = "roundcube";
      sopsFile = ./roundcubeSecrets.yaml;
      format = "yaml";
      key = "roundcube_client_secret";
      restartUnits = [ "phpfpm-roundcube.service" ];
    };

    # ── Roundcube Service ─────────────────────────────────────────────────
    services.roundcube = {
      enable = true;
      hostName = cfg.fullDomainName;
      database = {
        host = "localhost";
        dbname = "roundcube";
        username = "roundcube";
      };
      plugins = [ "oauth" ];
      extraConfig = ''
        $config['mail_domain'] = '${domain}';
        $config['imap_host'] = 'ssl://${mailServerCfg.fullDomainName}:993';
        $config['smtp_host'] = 'ssl://${mailServerCfg.fullDomainName}:465';
        $config['use_https'] = true;

        // OAuth / OpenID Connect via Kanidm
        $config['oauth_provider'] = 'generic';
        $config['oauth_provider_name'] = 'Kanidm';
        $config['oauth_client_id'] = 'roundcube';
        $config['oauth_client_secret'] = trim(file_get_contents('${config.sops.secrets."roundcube/clientSecret".path}'));
        $config['oauth_auth_uri'] = 'https://${ssoCfg.fullDomainName}/ui/oauth2';
        $config['oauth_token_uri'] = 'https://${ssoCfg.fullDomainName}/oauth2/token';
        $config['oauth_identity_uri'] = 'https://${ssoCfg.fullDomainName}/oauth2/openid/roundcube/userinfo';
        $config['oauth_scope'] = 'openid email profile';
        $config['oauth_identity_fields'] = ['preferred_username'];
        $config['oauth_login_redirect'] = false;
      '';
    };

    # ── Nginx SSL/ACME ────────────────────────────────────────────────────
    # Disable enableACME (set by the Roundcube module) since we use the
    # shared wildcard certificate via useACMEHost instead.
    services.nginx.virtualHosts.${cfg.fullDomainName} = {
      enableACME = lib.mkForce false;
      forceSSL = true;
      useACMEHost = domain;
    };

    # ── Kanidm OAuth Registration ─────────────────────────────────────────
    server.services.singleSignOn.oAuthServices."roundcube" = {
      displayName = "Roundcube Webmail";
      originUrl = [ "https://${cfg.fullDomainName}/index.php/login/oauth" ];
      originLanding = "https://${cfg.fullDomainName}";
      basicSecretFile = config.sops.secrets."roundcube/oauth/client_secret".path;
      preferShortUsername = true;
      imageFile = ./roundcube.svg;
      groupName = "mail-users";
      scopes = [ "openid" "profile" "email" ];
      allowInsecureClientDisablePkce = true;
    };
  };
}