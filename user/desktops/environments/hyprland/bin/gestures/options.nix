{ config, lib, ... }:
{
  options.desktopEnvironments.hyprland.bin.gestures = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gestures for Hyprland.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      apply = x: lib.unique x;
      description = "Available gestures for Hyprland.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.desktopEnvironments.hyprland.bin.gestures.availableConfigs or []);
      default = "default";
      description = "Set the active gesture for Hyprland.";
    };
  };
}