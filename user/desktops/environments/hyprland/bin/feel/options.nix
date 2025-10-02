{ config, lib, ... }:
{
  options.desktopEnvironments.hyprland.bin.feel = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable feel for Hyprland.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      apply = x: lib.unique x;
      description = "Available feels for Hyprland.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.desktopEnvironments.hyprland.bin.feel.availableConfigs or []);
      default = "default";
      description = "Set the active feel for Hyprland.";
    };
  };
}