{ config, lib, ... }:
{
  home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.apps.hyprland.bin.decorations.enable && (config.theming.apps.hyprland.bin.decorations.activeConfig == "default")) {
    wayland.windowManager.hyprland.settings = {
      decoration = {
        rounding = 10;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;


        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = "on";
          ignore_opacity = "on";

          vibrancy = 0.1696;
        };
      };
    };
  };
}