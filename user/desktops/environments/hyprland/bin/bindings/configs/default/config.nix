{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.bindings.enable && (config.desktopEnvironments.hyprland.bin.bindings.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username} = {
      wayland.windowManager.hyprland.settings = {
        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];

        binde = [
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 2%-"
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 2%+"
          ",XF86MonBrightnessUp, exec, brightnessctl set 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl set 10%-"
          ",XF86KbdLightOnOff, exec, brightnessctl --device='asus::kbd_backlight' set $(if [[ $(brightnessctl --device='asus::kbd_backlight' g) -lt 3 ]]; then echo \"+1\"; else echo \"0\"; fi)"
        ];
      };
    };
  };
}