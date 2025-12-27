{ config, lib, ... }:
{
  config = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.enable && (config.theming.apps.waybar.modules.activeConfig == "custom1"))) {
    theming.apps.waybar.style = [
      {
        order = 200;
        content = ''
          .modules-left {
          	background: @base01;
           	border: 1px solid @module_border_color;
          	padding-right: 15px;
          	padding-left: 2px;
          	border-radius: 10px;
          }
          .modules-center {
          	background: @base01;
            border: 0.5px solid @base00;
          	padding-right: 5px;
          	padding-left: 5px;
          	border-radius: 10px;
          }
          .modules-right {
          	background: @base01;
           	border: 1px solid @module_border_color;
          	padding-right: 15px;
          	padding-left: 15px;
          	border-radius: 10px;
          }

          #backlight,
          #backlight-slider,
          #battery,
          #bluetooth,
          #clock,
          #cpu,
          #disk,
          #idle_inhibitor,
          #keyboard-state,
          #memory,
          #mode,
          #mpris,
          #network,
          #pulseaudio,
          #pulseaudio-slider,
          #taskbar button,
          #taskbar,
          #temperature,
          #tray,
          #window,
          #wireplumber,
          #workspaces,
          #custom-backlight,
          #custom-cycle_wall,
          #custom-gpuinfo,
          #custom-keybinds,
          #custom-keyboard,
          #custom-light_dark,
          #custom-lock,
          #custom-menu,
          #custom-power_vertical,
          #custom-power,
          #custom-swaync,
          #custom-updater,
          #custom-weather,
          #custom-weather.clearNight,
          #custom-weather.cloudyFoggyDay,
          #custom-weather.cloudyFoggyNight,
          #custom-weather.default,
          #custom-weather.rainyDay,
          #custom-weather.rainyNight,
          #custom-weather.severe,
          #custom-weather.showyIcyDay,
          #custom-weather.snowyIcyNight,
          #custom-weather.sunnyDay {
          	padding-top: 3px;
          	padding-bottom: 3px;
          	padding-right: 5px;
          	padding-left: 5px;
          }
        '';
      }
    ];
  };
}