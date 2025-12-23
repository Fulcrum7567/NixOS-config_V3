{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.apps.waybar.enable && (config.desktopEnvironments.hyprland.bin.apps.waybar.activeConfig == "custom1")) {
    packages.waybar = {
      enable = true;
      activeConfig = "custom1";
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