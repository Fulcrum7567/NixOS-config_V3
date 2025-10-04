{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.cava = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.cava.enable;
      description = "Enable cava module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available cava module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.cava.availableConfigs or []);
      default = config.packages.waybar.modules.cava.activeConfig or "default";
      description = "Active cava module configuration for waybar.";
    };
  };
}