{ config, lib, ... }:
{
  config.home-manager.users.${config.user.settings.username}.wayland.windowManager.hyprland.settings = lib.mkIf config.home-manager.users.${config.user.settings.username}.wayland.windowManager.hyprland.enable {
    env = [
      "XCURSOR_SIZE, ${toString config.theming.cursors.size}"
      "HYPRCURSOR_SIZE, ${toString config.theming.cursors.size}"
    ];

    exec-once = [
      "hyprctl setcursor ${config.theming.cursors.name}, ${toString config.theming.cursors.size}"
    ];
  };
}