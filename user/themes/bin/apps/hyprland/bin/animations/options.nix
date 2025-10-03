{ config, lib, ... }:
{
  options.theming.apps.hyprland.bin.animations = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Hyprland animations.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Hyprland animations configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.hyprland.bin.animations.availableConfigs or []);
      default = "default";
      description = "The active Hyprland animations configuration.";
    };
  };
}