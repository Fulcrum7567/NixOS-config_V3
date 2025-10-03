{ config, lib, ... }:
{
  options.packages.waybar.modules.clock = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the clock module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      apply = x: lib.unique x;
      description = "List of all available configs for the clock module.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.packages.waybar.modules.clock.availableConfigs or []);
      default = "default"; # A default config should always exist, delete if not
      description = "Set the active configuration for the clock module.";
    };
  };
}