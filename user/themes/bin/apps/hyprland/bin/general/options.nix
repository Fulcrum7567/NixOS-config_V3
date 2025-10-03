{ config, lib, ... }:
{
  options.theming.apps.hyprland.bin.general = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Hyprland general settings.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Hyprland general configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.hyprland.bin.general.availableConfigs or []);
      default = "default";
      description = "The active Hyprland general configuration.";
    };
  };
}