{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.feel.enable && (config.desktopEnvironments.hyprland.bin.feel.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username} = {
      wayland.windowManager.hyprland.settings = {
        general = {
          resize_on_border = true;
          snap.enable = true;
        };
      };
    };
  };
}