{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.network.enable && (config.theming.apps.waybar.modules.network.activeConfig == "slyHarvey"))) {
    style = [
      {
        content = ''
          #network {
            color: @blue;
          }
          #network.disconnected,
          #network.disabled {
            background-color: @surface0;
            color: @text;
          }
        '';
      }
    ];
  };
}