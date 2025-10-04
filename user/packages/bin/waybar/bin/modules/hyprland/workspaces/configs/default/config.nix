{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.hyprland.workspaces.enable && (config.packages.waybar.modules.hyprland.workspaces.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          urgent = "";
          active = "";
          default = "";
        };
        sort-by-number = true;
      };
    };
  };
}