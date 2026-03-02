{ config, lib, ... }:
{
  options.server.services.vert = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the VERT file converter service.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available VERT configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.services.vert.availableConfigs or []);
      default = "default";
      description = "The active VERT configuration.";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 3100;
      description = "The host port for the VERT container.";
    };

    oauthProxyPort = lib.mkOption {
      type = lib.types.int;
      default = 3101;
      description = "The port for the OAuth2 proxy in front of VERT.";
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "vert";
      description = "The subdomain to use for the VERT service.";
    };
  };
}
