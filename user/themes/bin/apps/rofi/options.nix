{ config, lib, ... }:
{
  options.theming.apps.rofi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = ((config.theming.activeTheme != null) && config.packages.rofi.enable);
      description = "Enable theming for Rofi.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "default" ];
      description = "List of available Rofi themes.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum (config.theming.apps.rofi.availableConfigs or []));
      default = "default";
      description = "Active Rofi theme configuration.";
    };

    starConfig = lib.mkOption {
      type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
      default = [];
      description = "A list of Rofi theme fragments to be recursively merged.";
    };
    

    

  };
}