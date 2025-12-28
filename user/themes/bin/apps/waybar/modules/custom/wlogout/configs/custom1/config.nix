{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.custom.wlogout.enable && (config.theming.apps.waybar.modules.custom.wlogout.activeConfig == "custom1"))) {
    style = [
      {
        content = ''
          #custom-wlogout {
            padding-left: 6px;
            color: @module_icon_color;
          }
        '';
      }
    ];
  };
}