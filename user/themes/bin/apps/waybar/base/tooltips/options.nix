{ config, lib, ... }:
{
  options.theming.apps.waybar.tooltips = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.enable;
      description = "Enable tooltips theming for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available tooltips configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.tooltips.availableConfigs or []);
      default = config.packages.waybar.activeConfig or "default";
      description = "Active tooltips configuration for waybar.";
    };
  };
}