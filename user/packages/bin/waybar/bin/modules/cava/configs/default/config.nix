{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.cava.enable && (config.packages.waybar.modules.cava.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "cava" = {
        framerate = 30;
        autosens = 1;
        sensitivity = 100;
        bars = 14;
        lower_cutoff_freq = 50;
        higher_cutoff_freq = 10000;
        hide_on_silence = false;
        # format_silent = quiet;
        method = "pulse";
        source = "auto";
        stereo = true;
        reverse = false;
        bar_delimiter = 0;
        monstercat = false;
        waves = false;
        noise_reduction = 0.77;
        input_delay = 2;
        format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        actions = {
          on-click-right = "mode";
        };
      };
    };
  };
}