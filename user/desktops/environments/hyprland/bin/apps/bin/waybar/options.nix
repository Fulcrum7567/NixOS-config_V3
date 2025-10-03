{ config, lib, pkgs, ... }:
{
  options.desktopEnvironments.hyprland.bin.apps.waybar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Waybar for Hyprland.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available configurations for Waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.desktopEnvironments.hyprland.bin.apps.waybar.availableConfigs or []);
      default = "default";
      description = "Active configuration for Waybar.";
    };
  };
}