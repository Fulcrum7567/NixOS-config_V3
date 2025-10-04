{ config, lib, ... }:
{
  options.theming.apps.waybar.modules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.enable;
      description = "Enable modules theming for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available modules configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.availableConfigs or []);
      default = config.packages.waybar.activeConfig or "default";
      description = "Active modules configuration for waybar.";
    };
  };
}