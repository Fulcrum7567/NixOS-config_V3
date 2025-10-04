{ config, lib, ... }:
{
  options.theming.apps.waybar.colors = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.enable;
      description = "Enable color theming for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available color configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.colors.availableConfigs or []);
      default = config.packages.waybar.activeConfig or "default";
      description = "Active color configuration for waybar.";
    };
  };
}