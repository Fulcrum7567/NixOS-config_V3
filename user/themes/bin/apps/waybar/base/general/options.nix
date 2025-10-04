{ config, lib, ... }:
{
  options.theming.apps.waybar.general = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.enable;
      description = "Enable general theming for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available general configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.general.availableConfigs or []);
      default = config.packages.waybar.activeConfig or "default";
      description = "Active general configuration for waybar.";
    };
  };
}