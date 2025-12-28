{ config, lib, ... }:
{
  options.theming.apps.sddm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = ((config.theming.activeTheme != null) && (config.displayManagers.activeManager == "sddm"));
      description = "Enable SDDM theming support.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "default" ];
      description = "List of available SDDM theme configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.sddm.availableConfigs or []);
      default = "default";
      description = "The active SDDM theme configuration.";
    };
  };
}