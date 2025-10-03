{ config, lib, ... }:
{
  options.desktopEnvironments.hyprland.bin.bindings = {

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available configurations for Hyprland bindings.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.desktopEnvironments.hyprland.bin.bindings.availableConfigs or []);
      default = "default";
      description = "Active configuration for Hyprland bindings.";
    };

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable bindings for Hyprland.";
    };

    enableAutoMapping = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable automatic key mapping for Hyprland bindings.";
    };
  };
}