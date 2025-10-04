{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.cava.enable && (config.theming.apps.waybar.modules.cava.activeConfig == "slyHarvey"))) {
    style = [
      {
        content = ''
          #cava {
          	color: @pink;
          }
        '';
      }
    ];
  };
}