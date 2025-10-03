{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.apps.waybar.enable && (config.desktopEnvironments.hyprland.bin.apps.waybar.activeConfig == "slyHarvey")) {
    packages.waybar = {
      enable = true;
      activeConfig = "slyHarvey";
    };

    home-manager.users.${config.user.settings.username} = {
      wayland.windowManager.hyprland.settings = {
        exec-once = [
          "waybar"
        ];
      };
    };
  };
}