{ config, lib, ... }:
{
  options.packages.noctaliaShell.modules.dock = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the dock module for noctaliaShell.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      apply = x: lib.unique x;
      description = "List of all available configs for the dock module.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.packages.noctaliaShell.modules.dock.availableConfigs or []);
      default = "default"; # A default config should always exist, delete if not
      description = "Set the active configuration for the dock module.";
    };
  };
}