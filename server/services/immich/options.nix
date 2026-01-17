{ config, lib, ... }:
{
  options.server.services.immich = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Immich service.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Syncthing configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.services.immich.availableConfigs or []);
      default = "default";
      description = "The active Immich configuration.";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 2283;
      description = "Port for Immich web interface.";
    };

    defaultDataDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.server.system.filesystem.defaultDataDir}/immich";
      description = "Default directory to save Immich configurations.";
    };

    exposeGUI = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Expose Immich web GUI via reverse proxy.";
    };

  };
}