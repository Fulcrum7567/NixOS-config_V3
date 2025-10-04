{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.bluetooth.enable && (config.theming.apps.waybar.modules.bluetooth.activeConfig == "slyHarvey"))) {
    style = [
      {
        content = ''
          #bluetooth {
            color: @blue;
          }
        '';
      }
    ];
  };
}