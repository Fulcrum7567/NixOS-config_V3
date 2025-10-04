{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.hyprland.workspaces.enable && (config.packages.waybar.modules.hyprland.workspaces.activeConfig == "slyHarvey")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        active-only = false;
        on-click = "activate";
        persistent-workspaces = {
          "*" = [
            1
            2
            3
            4
            5
            6
            7
            8
            9
            10
          ];
        };
      };
    };
  };
}