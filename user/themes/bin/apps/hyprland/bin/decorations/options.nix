{ config, lib, ... }:
{
  options.theming.apps.hyprland.bin.decorations = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Hyprland decorations.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Hyprland decorations configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.hyprland.bin.decorations.availableConfigs or []);
      default = "default";
      description = "The active Hyprland decorations configuration.";
    };
  };
}