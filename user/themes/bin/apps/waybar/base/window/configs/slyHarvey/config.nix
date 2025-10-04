{ config, lib, ... }:
{
  config = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.window.enable && (config.theming.apps.waybar.window.activeConfig == "slyHarvey"))) {
    theming.apps.waybar.style = [
      {
        order = 150;
        content = ''
          window#waybar {
            transition-property: background-color;
            transition-duration: 0.5s;
            background: transparent;
            /*border: 2px solid @overlay0;*/
            /*background: @theme_base_color;*/
            border-radius: 10px;
          }

          window#waybar.hidden {
            opacity: 0.2;
          }
        '';
      }
    ];
  };
}