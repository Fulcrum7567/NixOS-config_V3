{ config, lib, pkgs, ... }:
{
  options.desktopEnvironments.hyprland.bin.apps.rofi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Rofi for Hyprland.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available configurations for Rofi.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.desktopEnvironments.hyprland.bin.apps.rofi.availableConfigs or []);
      default = "default";
      description = "Active configuration for Rofi.";
    };
  };
}