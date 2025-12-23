{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.battery.enable && (config.theming.apps.waybar.modules.battery.activeConfig == "custom1"))) {
    style = [
      {
        content = ''
          #battery {
            color: @blue;
          }
          #battery.critical {
            color: @red;
          }
          #battery.charging {
            color: @green;
          }
        '';
      }
    ];
  };
}