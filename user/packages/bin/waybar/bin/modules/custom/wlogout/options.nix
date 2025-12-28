{ config, lib, ... }:
{
  options.packages.waybar.modules.custom.wlogout = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the wlogout module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      apply = x: lib.unique x;
      description = "List of all available configs for the wlogout module.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.packages.waybar.modules.custom.wlogout.availableConfigs or []);
      default = "default"; # A default config should always exist, delete if not
      description = "Set the active configuration for the wlogout module.";
    };
  };
}