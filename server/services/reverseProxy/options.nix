{ config, lib, ... }:
{
  options.server.services.reverseProxy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = (config.host.settings.systemType == "server");
      description = "Enable the reverse proxy service.";
    };
    
    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available reverse proxy configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.services.reverseProxy.availableConfigs or []);
      default = "nginx";
      description = "The active reverse proxy configuration.";
    };

    activeRedirects = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          from = lib.mkOption {
            type = lib.types.str;
            description = "The address to redirect from (e.g. domain).";
            example = "myservice.example.com";
          };
          useACMEHost = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to use the 'from' host for ACME certificate generation.";
          };
          forceSSL = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to force SSL redirection for this redirect.";
          };

          locations = lib.mkOption {
            type = lib.types.attrsOf (lib.types.submodule {
              options = {
                path = lib.mkOption {
                  type = lib.types.str;
                  default = "/";
                  description = "The URL path for this location.";
                };
                to = lib.mkOption {
                  type = lib.types.str;
                  description = "The backend address to proxy to (e.g. IP:port).";
                  example = "127.0.0.1:8096";
                };
                proxyWebsockets = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Whether to enable WebSocket proxying for this location.";
                };
                extraConfig = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "Additional configuration directives for this location.";
                };
              };
            });
            default = { };
            description = "Configuration for specific URL paths.";
          };
        };
      });
      default = { };
      description = "Configuration for active redirects.";
    };

  };
}