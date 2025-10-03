{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.mpris.enable && (config.packages.waybar.modules.mpris.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "mpris" = {
        format = "DEFAULT: {player_icon} {dynamic}";
        format-paused = "DEFAULT: {status_icon} <i>{dynamic}</i>";
        player-icons = {
          default = "▶";
          mpv = "🎵";
        };
        status-icons = {
          paused = "⏸";
        };
      };
    };
  };
}