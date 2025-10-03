{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.mpris.enable && (config.packages.waybar.modules.mpris.activeConfig == "slyHarvey")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "mpris" = {
        format = "{player_icon} {title} - {artist}";
        format-paused = "{status_icon} <i>{title} - {artist}</i>";
        player-icons = {
          default = "▶";
          spotify = "";
          mpv = "󰐹";
          vlc = "󰕼";
          firefox = "";
          chromium = "";
          kdeconnect = "";
          mopidy = "";
        };
        status-icons = {
          paused = "⏸";
          playing = "";
        };
        ignored-players = [ ];
        max-length = 30;
      };
    };
  };
}