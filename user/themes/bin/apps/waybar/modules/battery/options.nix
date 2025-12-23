{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.battery = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.battery.enable;
      description = "Enable battery module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available battery module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.battery.availableConfigs or []);
      default = config.packages.waybar.modules.battery.activeConfig or "default";
      description = "Active battery module configuration for waybar.";
    };
  };
}