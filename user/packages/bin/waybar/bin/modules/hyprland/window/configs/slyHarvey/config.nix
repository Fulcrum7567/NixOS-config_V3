{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.hyprland.window.enable && (config.packages.waybar.modules.hyprland.window.activeConfig == "slyHarvey")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "hyprland/window" = {
        format = "  {}";
        separate-outputs = true;
        rewrite = {
          "harvey@hyprland =(.*)" = "$1 ";
          "(.*) — Mozilla Firefox" = "$1 󰈹";
          "(.*)Mozilla Firefox" = " Firefox 󰈹";
          "(.*) - Visual Studio Code" = "$1 󰨞";
          "(.*)Visual Studio Code" = "Code 󰨞";
          "(.*) — Dolphin" = "$1 󰉋";
          "(.*)Spotify" = "Spotify 󰓇";
          "(.*)Spotify Premium" = "Spotify 󰓇";
          "(.*)Steam" = "Steam 󰓓";
        };
        max-length = 1000;
      };
    };
  };
}