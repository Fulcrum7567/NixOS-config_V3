{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.powerProfile.enable && (config.theming.apps.waybar.modules.powerProfile.activeConfig == "custom1"))) {
    style = [
      {
        content = ''
          #power-profiles-daemon {
            color: @module_icon_color;
          }
        '';
      }
    ];
  };
}