{ config, lib, ... }:
{
  options.theming.apps.wlogout = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = ((config.theming.activeTheme != null) && (config.packages.wlogout.enable));
      description = "Enable Wlogout theming support.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Wlogout theme configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.wlogout.availableConfigs or []);
      default = config.packages.wlogout.activeConfig or "default";
      description = "The active Wlogout theme configuration.";
    };
  };
}