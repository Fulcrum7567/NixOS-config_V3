{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.apps.waybar.enable && (config.desktopEnvironments.hyprland.bin.apps.waybar.activeConfig == "default")) {
    packages.waybar.enable = true;

    home-manager.users.${config.user.settings.username} = {
      wayland.windowManager.hyprland.settings = {
        exec-once = [
          "waybar"
        ];
      };
    };
  };
}