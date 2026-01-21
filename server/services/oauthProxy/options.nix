{ config, lib, ... }:

with lib;

let
  # define the submodule for each service instance
  proxyOptions = { name, config, ... }: {
    options = {
      provider = mkOption {
        type = types.str;
        default = "oidc";
        description = "OAuth provider";
      };
      clientID = mkOption {
        type = types.str;
        description = "OAuth Client ID";
      };
      clientSecretFile = mkOption {
        type = types.path;
        description = "Path to file containing the client secret";
      };
      cookieSecretFile = mkOption {
        type = types.path;
        description = "Path to file containing the cookie secret";
      };
      upstream = mkOption {
        type = types.listOf types.str;
        description = "List of upstream endpoints to proxy to";
      };
      httpAddress = mkOption {
        type = types.str;
        default = "127.0.0.1:4180";
        description = "Address to listen on (host:port)";
      };
      oidcIssuerUrl = mkOption {
        type = types.str;
        description = "OIDC Issuer URL";
      };
      emailDomains = mkOption {
        type = types.listOf types.str;
        default = [ "*" ];
        description = "Allowed email domains";
      };
      extraConfig = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "Extra configuration key-values (e.g. redirect-url, pass-access-token)";
      };
    };
  };

in
{
  options.server.services.oauthProxy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable OAuth Proxy service.";
    };

    services = mkOption {
      description = "Map of oauth2-proxy service definitions";
      type = types.attrsOf (types.submodule proxyOptions);
      default = {};
    };
    

  };
}