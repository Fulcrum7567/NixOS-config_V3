{ config, lib, ... }:
{
  options.theming.apps.hyprland.bin.misc = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Hyprland miscellaneous settings.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Hyprland miscellaneous configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.hyprland.bin.misc.availableConfigs or []);
      default = "default";
      description = "The active Hyprland miscellaneous configuration.";
    };
  };
}