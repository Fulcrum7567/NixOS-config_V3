{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.input.enable && (config.desktopEnvironments.hyprland.bin.input.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username} = {
      wayland.windowManager.hyprland.settings = {
        input = {
          kb_layout = "de";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = 1;

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

          accel_profile = "flat"; # "flat", "adaptive", "custom"

          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            tap-to-click = true;
          };
        };
      };
    };
  };
}