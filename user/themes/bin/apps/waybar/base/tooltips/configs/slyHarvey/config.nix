{ config, lib, ... }:
{
  config = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.tooltips.enable && (config.theming.apps.waybar.tooltips.activeConfig == "slyHarvey"))) {
    theming.apps.waybar.style = [
      {
        order = 150;
        content = ''
          tooltip {
            background: #1e1e2e;
            border-radius: 8px;
          }

          tooltip label {
            color: #cad3f5;
            margin-right: 5px;
            margin-left: 5px;
          }
        '';
      }
    ];
  };
}