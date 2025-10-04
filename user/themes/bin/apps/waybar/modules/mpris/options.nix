{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.mpris = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.mpris.enable;
      description = "Enable mpris module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available mpris module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.mpris.availableConfigs or []);
      default = config.packages.waybar.modules.mpris.activeConfig or "default";
      description = "Active mpris module configuration for waybar.";
    };
  };
}