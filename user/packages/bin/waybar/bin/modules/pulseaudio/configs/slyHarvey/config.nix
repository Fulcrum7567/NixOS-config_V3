{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.pulseaudio.enable && (config.packages.waybar.modules.pulseaudio.activeConfig == "slyHarvey")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "pulseaudio" = {
        format = "{icon} {volume}";
        format-muted = " ";
        on-click = "pavucontrol -t 3";
        tooltip-format = "{icon} {desc} // {volume}%";
        scroll-step = 4;
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