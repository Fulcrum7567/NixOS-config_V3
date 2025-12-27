{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.battery.enable && (config.theming.apps.waybar.modules.battery.activeConfig == "custom1"))) {
    style = [
      {
        content = ''
          #battery {
            color: @module_icon_color;
            /* 1. Reset padding so it doesn't add to the height */
            padding-top: 0;
            padding-bottom: 0;

            /* 2. Aggressive negative margins. 
              Start with -10px. If the bar is still too tall, try -15px or -20px. */
            margin-top: -20px;
            margin-bottom: -20px;
            
            /* 3. Optional: Ensure the background doesn't look weird if you use one */
            background-color: transparent;
          }
          #battery.critical {
            color: @base08;
          }
          #battery.charging {
            color: @base0B;
          }
        '';
      }
    ];
  };
}