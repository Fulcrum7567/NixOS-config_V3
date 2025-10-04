{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.clock.enable && (config.theming.apps.waybar.modules.clock.activeConfig == "slyHarvey"))) {
    style = [
      {
        content = ''
          #clock {
            color: @yellow;
          }
        '';
      }
    ];
  };
}