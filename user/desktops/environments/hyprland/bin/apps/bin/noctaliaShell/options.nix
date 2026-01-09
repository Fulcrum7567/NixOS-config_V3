{ config, lib, pkgs, ... }:
{
  options.desktopEnvironments.hyprland.bin.apps.noctaliaShell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable NoctaliaShell for Hyprland.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available configurations for NoctaliaShell.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.desktopEnvironments.hyprland.bin.apps.noctaliaShell.availableConfigs or []);
      default = "default";
      description = "Active configuration for NoctaliaShell.";
    };
  };
}