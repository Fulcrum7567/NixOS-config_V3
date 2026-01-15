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
      default = "caddy";
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
          to = lib.mkOption {
            type = lib.types.str;
            description = "The address to redirect to (e.g. localhost:port).";
            example = "127.0.0.1:8096";
          };
        };
      });
      default = { };
      description = "Configuration for active redirects.";
    };

  };
}