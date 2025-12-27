{ config, lib, ... }:
{
  config = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.tooltips.enable && (config.theming.apps.waybar.tooltips.activeConfig == "custom1"))) {
    theming.apps.waybar.style = [
      {
        order = 150;
        content = ''
          tooltip {
            background: @base00;
            border-radius: 8px;
          }

          tooltip label {
            color: @base05;
            margin-right: 5px;
            margin-left: 5px;
          }
        '';
      }
    ];
  };
}