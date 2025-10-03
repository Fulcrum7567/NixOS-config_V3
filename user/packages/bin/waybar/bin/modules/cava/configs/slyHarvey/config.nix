{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.cava.enable && (config.packages.waybar.modules.cava.activeConfig == "slyHarvey")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "cava" = {
        hide_on_silence = true;
        framerate = 60;
        bars = 10;
        format-icons = [
          "▁"
          "▂"
          "▃"
          "▄"
          "▅"
          "▆"
          "▇"
          "█"
        ];
        input_delay = 1;
        # "noise_reduction" = 0.77;
        sleep_timer = 5;
        bar_delimiter = 0;
        on-click = "playerctl play-pause";
      };
    };
  };
}