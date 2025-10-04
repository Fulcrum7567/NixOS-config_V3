{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.hyprland.window.enable && (config.packages.waybar.modules.hyprland.window.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "hyprland/window" = {
        format = "👉 {}";
        rewrite = {
          "(.*) — Mozilla Firefox" = "🌎 $1";
          "(.*) - fish" = "> [$1]";
        };
        separate-outputs = true;
      };
    };
  };
}