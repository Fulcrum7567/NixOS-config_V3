{ config, lib, ... }:
{
  options.server.services.syncthing = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Syncthing service.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Syncthing configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.services.syncthing.availableConfigs or []);
      default = null;
      description = "The active Syncthing configuration.";
    };

    defaultDataDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.server.system.filesystem.defaultDataDir}/syncthing";
      description = "Default directory to save Syncthing configurations.";
    };

  };
}