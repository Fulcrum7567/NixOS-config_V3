{ config, lib, currentHost, ... }:
{
  options.server.system.filesystem.disko = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = (config.host.settings.systemType == "server");
      description = "Enable disko for managing filesystems.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available disko filesystem configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.system.filesystem.disko.availableConfigs or []);
      default = currentHost;
      description = "The active disko filesystem configuration.";
    };

    # Todo: multiple disks possible
    diskId = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "The disk ID to manage with disko.";
    };
  };
}