{ config, lib, ... }:
{
  options.server.services.autoBackup = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable automatic backups for the server.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "default" ];
      description = "List of available auto backup configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.services.autoBackup.availableConfigs or []);
      default = "default";
      description = "The active auto backup configuration.";
    };
  };
}