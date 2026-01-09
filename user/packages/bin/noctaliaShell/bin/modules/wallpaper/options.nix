{ config, lib, ... }:
{
  options.packages.noctaliaShell.modules.wallpaper = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the wallpaper module for noctaliaShell.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      apply = x: lib.unique x;
      description = "List of all available configs for the screenRecorder module.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.packages.noctaliaShell.modules.wallpaper.availableConfigs or []);
      default = "default"; # A default config should always exist, delete if not
      description = "Set the active configuration for the wallpaper module.";
    };
  };
}