{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.pulseaudio.enable && (config.theming.apps.waybar.modules.pulseaudio.activeConfig == "custom1"))) {
    style = [
      {
        content = ''
          #pulseaudio {
            color: @blue;
            /* 1. Reset padding so it doesn't add to the height */
            padding-top: 0;
            padding-bottom: 0;

            /* 2. Aggressive negative margins. 
              Start with -10px. If the bar is still too tall, try -15px or -20px. */
            margin-top: -20px;
            margin-bottom: -20px;
          }

          #pulseaudio-slider slider {
          	min-width: 0px;
          	min-height: 0px;
          	opacity: 0;
          	background-image: none;
          	border: none;
          	box-shadow: none;
          }

          #pulseaudio-slider trough {
          	min-width: 80px;
          	min-height: 5px;
          	border-radius: 5px;
          }

          #pulseaudio-slider highlight {
          	min-height: 10px;
          	border-radius: 5px;
          }
        '';
      }
    ];
  };
}