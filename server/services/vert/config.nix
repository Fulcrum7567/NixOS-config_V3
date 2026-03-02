{ config, lib, pkgs-default, ... }:
let
  cfg = config.server.services.vert;
  domain = "${cfg.subdomain}.${config.server.webaddress}";
  clientId = "vert";
in
{
  config = lib.mkIf cfg.enable {

    # Enable Docker
    packages.docker.enable = true;

    # SOPS secrets for OAuth
    sops.secrets."vert/oauth/client_secret" = {
      owner = config.server.services.singleSignOn.serviceUsername;
      group = config.server.services.singleSignOn.serviceGroup;
      sopsFile = ./vertSecrets.yaml;
      format = "yaml";
      key = "vert_oauth_client_secret";
      restartUnits = [ "kanidm.service" ];
      mode = "0440";
    };

    sops.secrets."vert/oauth/proxy_client_secret" = {
      sopsFile = ./vertSecrets.yaml;
      format = "yaml";
      key = "vert_oauth_client_secret";
      restartUnits = [ "oauth2-proxy-vert.service" ];
    };

    sops.secrets."vert/oauth/proxy_cookie_secret" = {
      sopsFile = ./vertSecrets.yaml;
      format = "yaml";
      key = "vert_oauth_cookie_secret";
      restartUnits = [ "oauth2-proxy-vert.service" ];
    };

    # VERT Docker container
    virtualisation.oci-containers.backend = "docker";
    virtualisation.oci-containers.containers."vert" = {
      image = "ghcr.io/vert-sh/vert:latest";
      ports = [ "127.0.0.1:${toString cfg.port}:80" ];
    };

    # Reverse proxy points to the OAuth2 proxy
    server.services.reverseProxy.activeRedirects."vert" = {
      subdomain = cfg.subdomain;
      useACMEHost = true;
      forceSSL = true;
      locations."/" = {
        path = "/";
        to = "http://127.0.0.1:${toString cfg.oauthProxyPort}";
        proxyWebsockets = true;
      };
    };

    # OAuth2 Proxy sits between nginx and VERT
    server.services.oauthProxy = {
      enable = true;
      services."vert" = {
        provider = "oidc";
        clientID = clientId;
        httpAddress = "127.0.0.1:${toString cfg.oauthProxyPort}";
        upstream = [ "http://127.0.0.1:${toString cfg.port}" ];
        clientSecretFile = config.sops.secrets."vert/oauth/proxy_client_secret".path;
        cookieSecretFile = config.sops.secrets."vert/oauth/proxy_cookie_secret".path;
        oidcIssuerUrl = "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/${clientId}";
        extraConfig = {
          redirect_url = "https://${domain}/oauth2/callback";
          code_challenge_method = "S256";
          skip_provider_button = "true";
          pass_access_token = "true";
          pass_authorization_header = "true";
          set_xauthrequest = "true";
        };
      };
    };

    # SSO registration
    server.services.singleSignOn.oAuthServices."${clientId}" = {
      displayName = "VERT";
      originUrl = [ "https://${domain}/oauth2/callback" ];
      originLanding = "https://${domain}";
      basicSecretFile = config.sops.secrets."vert/oauth/client_secret".path;
      preferShortUsername = true;
      groupName = "vert-users";
      scopes = [ "openid" "profile" "email" ];
    };
  };
}
