{ config, lib, ... }:
{
  options.theming.plymouth = {

    availableThemes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      apply = x: lib.unique x;
      description = "List of all available Plymouth themes.";
    };

    activeTheme = lib.mkOption {
      type = lib.types.enum (config.theming.plymouth.availableThemes or []);
      default = "default";
      description = "The active Plymouth theme.";
    };

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Plymouth theme.";
    };
  };
}