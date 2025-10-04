{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.bluetooth = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.bluetooth.enable;
      description = "Enable bluetooth module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available bluetooth module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.bluetooth.availableConfigs or []);
      default = config.packages.waybar.modules.bluetooth.activeConfig or "default";
      description = "Active bluetooth module configuration for waybar.";
    };
  };
}