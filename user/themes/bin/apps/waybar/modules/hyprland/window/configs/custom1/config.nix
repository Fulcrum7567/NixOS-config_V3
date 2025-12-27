{ config, lib, ... }:
{
  config.theming.apps.waybar = lib.mkIf (config.theming.apps.waybar.enable && (config.theming.apps.waybar.modules.hyprland.window.enable && (config.theming.apps.waybar.modules.hyprland.window.activeConfig == "custom1"))) {
    style = [
      {
        content = ''
          #window {
            color: @base0F;
          }
        '';
      }
    ];
  };
}