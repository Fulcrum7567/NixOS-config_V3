{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.powerProfile = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.powerProfile.enable;
      description = "Enable powerProfile module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available powerProfile module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.powerProfile.availableConfigs or []);
      default = config.packages.waybar.modules.powerProfile.activeConfig or "default";
      description = "Active powerProfile module configuration for waybar.";
    };
  };
}