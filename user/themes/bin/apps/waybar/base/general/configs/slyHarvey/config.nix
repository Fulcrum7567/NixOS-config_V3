{ config, lib, ... }:
{
  config = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.general.enable && (config.theming.apps.waybar.general.activeConfig == "slyHarvey"))) {
    theming.apps.waybar.style = [
      {
        order = 50;
        content = ''
          * {
            font-family: "monospace";
            font-size: 14px;
            margin: 0px;
            padding: 0px;
          }
        '';
      }
    ];
  };
}