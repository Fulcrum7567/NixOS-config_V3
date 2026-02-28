{ config, lib, ... }:
{
  options.server.services.vscodeServer = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable VSCode Server service.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available VSCode Server configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.services.vscodeServer.availableConfigs or []);
      default = "default";
      description = "The active VSCode Server configuration.";
    };

  };
}