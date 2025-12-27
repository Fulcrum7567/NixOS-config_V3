{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.pulseaudio.enable && (config.packages.waybar.modules.pulseaudio.activeConfig == "custom1")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "pulseaudio" = {
        format = "<span size='250%'>{icon}</span> <span rise='7800'>{volume}%</span>";
        format-muted = "<span size='250%'></span>";
        format-bluetooth = "<span size='250%'>󰥰</span>";
        on-click = "pavucontrol -t 3";
        on-click-middle = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        tooltip-format = "{icon} {desc} {volume}%";
        scroll-step = 2;
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
            ""
          ];
        };
      };

      "pulseaudio#microphone" = {
        format = "{format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        on-click = "pavucontrol -t 4";
        tooltip-format = "{format_source} {source_desc} // {source_volume}%";
        scroll-step = 5;
      };
    };
  };
}