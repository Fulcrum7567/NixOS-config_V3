{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.apps.rofi.enable && (config.desktopEnvironments.hyprland.bin.apps.rofi.activeConfig == "default")) {
    packages.defaults.appLauncher.active = "rofi";
  };
}