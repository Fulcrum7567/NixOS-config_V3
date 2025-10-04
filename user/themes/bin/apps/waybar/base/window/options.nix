{ config, lib, ... }:
{
  options.theming.apps.waybar.window = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.enable;
      description = "Enable window theming for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available window configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.window.availableConfigs or []);
      default = config.packages.waybar.activeConfig or "default";
      description = "Active window configuration for waybar.";
    };
  };
}