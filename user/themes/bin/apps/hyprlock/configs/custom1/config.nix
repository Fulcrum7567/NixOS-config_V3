{ config, lib, ... }:
let
  primaryMonitor = lib.filter (m: m.primary) (lib.attrValues config.hardware.displays);
  monitor = if primaryMonitor != [] then (lib.head primaryMonitor).name else "";
in
{
  config = lib.mkIf (config.theming.apps.hyprlock.enable && (config.theming.apps.hyprlock.activeConfig == "custom1")) {
    home-manager.users.${config.user.settings.username} = {

      wayland.windowManager.hyprland.settings = {
        misc = {
          session_lock_xray = true;
        };
      };

      stylix.targets.hyprlock.enable = false;

      programs.hyprlock = {
        settings = {

          general = {
            hide_cursor = true;
            ignore_empty_password = true;
          };

          animations = {
            enabled = true;

            global = {
              fade = {
                fadeIn = true;
                fadeOut = true;
              };
            };
          };

          background = [
            {
              path = "screenshot";
              #path = "${config.theming.wallpaper.wallpaperPath}/${config.theming.wallpaper.single.active}";
              blur_passes = 2; # 0 disables blurring
              blur_size = 8;
              noise = 0.0117;
              contrast = 0.8916;
              brightness = 0.8172;
              vibrancy = 0.1696;
              vibrancy_darkness = 0.0;
            }
          ];

          input-field = [
            {
              size = "250, 60";
              position = "0, -80";
              monitor = monitor;
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(${config.colorScheme.palette.base05})";
              inner_color = "rgb(${config.colorScheme.palette.base00})";
              outer_color = "rgb(${config.colorScheme.palette.base0D})";
              outline_thickness = 2;
              placeholder_text = let
                inherit (config.colorScheme.palette) base05;
                # Adjust spacing to position icon left and password center
                pad = "         "; 
              in 
                if (config.hosts.components.fingerprint.enable) then
                  ''<span foreground="##${base05}" font_size="20pt">󰈷</span>${pad}<span foreground="##${base05}" rise='4000'>Password...${pad}</span>''
                else
                  ''<span foreground="##${base05}">Password...</span>'';
              shadow_passes = 2;
            }
          ];

          label = [
            {
              monitor = monitor;
              text = "$TIME";
              color = "rgba(${config.colorScheme.palette.base05}ff)";
              font_size = 64;
              font_family = "Noto Sans";
              position = "0, 80";
              halign = "center";
              valign = "center";
            }
          ];
        };
      };
    };
  };
}