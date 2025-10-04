{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.mpris.enable && (config.theming.apps.waybar.modules.mpris.activeConfig == "slyHarvey"))) {
    style = [
      {
        content = ''
          #mpris {
          	color: @pink;
          }
        '';
      }
    ];
  };
}