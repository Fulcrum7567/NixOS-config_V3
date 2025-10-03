{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.tray.enable && (config.packages.waybar.modules.tray.activeConfig == "slyHarvey")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      "tray" = {
        icon-size = 12;
        spacing = 5;
      };
    };
  };
}