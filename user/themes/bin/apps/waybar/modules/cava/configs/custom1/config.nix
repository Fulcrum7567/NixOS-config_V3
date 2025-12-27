{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.cava.enable && (config.theming.apps.waybar.modules.cava.activeConfig == "custom1"))) {
    style = [
      {
        content = ''
          #cava {
          	color: @base0A;
          }
        '';
      }
    ];
  };
}