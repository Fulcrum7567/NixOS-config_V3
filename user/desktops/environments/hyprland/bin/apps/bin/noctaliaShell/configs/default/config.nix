{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.apps.noctaliaShell.enable && (config.desktopEnvironments.hyprland.bin.apps.noctaliaShell.activeConfig == "default")) {
    packages.noctaliaShell.enable = true;

    home-manager.users.${config.user.settings.username} = {
      wayland.windowManager.hyprland.settings = {
        exec-once = [
          "noctalia-shell"
        ];
      };
    };
  };
}