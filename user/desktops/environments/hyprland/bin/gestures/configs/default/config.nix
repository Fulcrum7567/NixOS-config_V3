{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.gestures.enable && (config.desktopEnvironments.hyprland.bin.gestures.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username} = {
      wayland.windowManager.hyprland.settings = {
        gestures = {
          workspace = true;
          workspace_swipe_touch = true;
        };
      };
    };
  };
}