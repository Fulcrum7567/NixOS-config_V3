{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.custom.wlogout = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.custom.wlogout.enable;
      description = "Enable wlogout module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available bluetooth module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.custom.wlogout.availableConfigs or []);
      default = config.packages.waybar.modules.custom.wlogout.activeConfig or "default";
      description = "Active wlogout module configuration for waybar.";
    };
  };
}