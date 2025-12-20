{ config, lib, ... }:
{
  config = lib.mkIf (config.desktopEnvironments.hyprland.bin.apps.rofi.enable && (config.desktopEnvironments.hyprland.bin.apps.rofi.activeConfig == "slyHarvey")) {
    packages.defaults.appLauncher.active = "rofi";
    packages.rofi = {
      enable = true;
      activeConfig = "slyHarvey";
    };
  };
}