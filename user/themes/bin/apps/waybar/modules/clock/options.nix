{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.clock = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.clock.enable;
      description = "Enable clock module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available clock module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.clock.availableConfigs or []);
      default = config.packages.waybar.modules.clock.activeConfig or "default";
      description = "Active clock module configuration for waybar.";
    };
  };
}