{ config, lib, pkgs, ... }:
{
  options.desktopEnvironments.hyprland.bin.apps.hyprpaper = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprpaper for Hyprland.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available configurations for Hyprpaper.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.desktopEnvironments.hyprland.bin.apps.hyprpaper.availableConfigs or []);
      default = "default";
      description = "Active configuration for Hyprpaper.";
    };
  };
}