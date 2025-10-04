{ config, lib, ... }:
{
  options.theming.apps.waybar.modules.pulseaudio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.packages.waybar.modules.pulseaudio.enable;
      description = "Enable pulseaudio module for waybar.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Available pulseaudio module configurations for waybar.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.theming.apps.waybar.modules.pulseaudio.availableConfigs or []);
      default = config.packages.waybar.modules.pulseaudio.activeConfig or "default";
      description = "Active pulseaudio module configuration for waybar.";
    };
  };
}