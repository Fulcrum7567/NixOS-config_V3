{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.gestures.enable && (config.desktopEnvironments.hyprland.bin.gestures.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username} = {
      wayland.windowManager.hyprland.settings = {
        gesture = [
          "3, horizontal, workspace"
          "3, up, mod: ALT, close"
        ];
      };
    };
  };
}