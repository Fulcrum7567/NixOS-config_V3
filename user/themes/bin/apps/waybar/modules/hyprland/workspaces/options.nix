{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.hyprland.workspaces = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.hyprland.workspaces.enable;
      description = "Enable hyprland workspaces module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available hyprland workspaces module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.hyprland.workspaces.availableConfigs or []);
      default = config.packages.waybar.modules.hyprland.workspaces.activeConfig or "default";
      description = "Active hyprland workspaces module configuration for waybar.";
    };
  };
}