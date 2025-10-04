{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.hyprland.window.enable && (config.theming.apps.waybar.modules.hyprland.window.activeConfig == "slyHarvey"))) {
    style = [
      {
        content = ''
          #window {
            color: @mauve;
          }
        '';
      }
    ];
  };
}