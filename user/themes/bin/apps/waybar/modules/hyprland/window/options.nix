{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.hyprland.window = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.hyprland.window.enable;
      description = "Enable hyprland window module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available hyprland window module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.hyprland.window.availableConfigs or []);
      default = config.packages.waybar.modules.hyprland.window.activeConfig or "default";
      description = "Active hyprland window module configuration for waybar.";
    };
  };
}