{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.apps.hyprpaper.enable && (config.desktopEnvironments.hyprland.bin.apps.hyprpaper.activeConfig == "default")) {
    packages.hyprpaper.enable = true;

    home-manager.users.${config.user.settings.username}.wayland.windowManager.hyprland.settings = {
        exec-once = [
          "hyprpaper"
        ];
      };
  };
}