{ config, lib, ... }:
{
  options.desktopEnvironments.hyprland.bin.input = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable input for Hyprland.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      apply = x: lib.unique x;
      description = "Available input methods for Hyprland.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.desktopEnvironments.hyprland.bin.input.availableConfigs or []);
      default = "default";
      description = "Set the active input method for Hyprland.";
    };
  };
}