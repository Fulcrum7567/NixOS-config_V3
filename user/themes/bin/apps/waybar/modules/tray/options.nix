{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.tray = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.tray.enable;
      description = "Enable tray module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available tray module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.tray.availableConfigs or []);
      default = config.packages.waybar.modules.tray.activeConfig or "default";
      description = "Active tray module configuration for waybar.";
    };
  };
}