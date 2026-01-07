{ config, lib, ... }:
{
  options.theming.apps.hyprlock = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = ((config.theming.activeTheme != null) && config.packages.hyprlock.enable);
      description = "Enable theming for Hyprlock.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Rofi themes.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum (config.theming.apps.hyprlock.availableConfigs or []));
      default = "custom1";
      description = "Active Hyprlock theme configuration.";
    };
  };
}