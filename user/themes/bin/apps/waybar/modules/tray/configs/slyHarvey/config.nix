{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.tray.enable && (config.theming.apps.waybar.modules.tray.activeConfig == "slyHarvey"))) {
    style = [
      {
        content = ''
          #tray > .passive {
            -gtk-icon-effect: dim;
          }
          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
          }
        '';
      }
    ];
  };
}