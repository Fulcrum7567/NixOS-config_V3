{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.network = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.network.enable;
      description = "Enable network module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available network module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.network.availableConfigs or []);
      default = config.packages.waybar.modules.network.activeConfig or "default";
      description = "Active network module configuration for waybar.";
    };
  };
}