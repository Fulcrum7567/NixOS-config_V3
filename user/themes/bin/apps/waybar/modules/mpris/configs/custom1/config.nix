{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.mpris.enable && (config.theming.apps.waybar.modules.mpris.activeConfig == "custom1"))) {
    style = [
      {
        content = ''
          #mpris {
          	color: @base0E;
          }
        '';
      }
    ];
  };
}