{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.battery.enable && (config.packages.waybar.modules.battery.activeConfig == "default")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      battery = {
        interval = 20;
        states = {
            warning = 30;
            critical = 15;
        };
        format = "{capacity}% {icon}";
        format-icons = ["" "" "" "" ""];
        max-length = 25;
      };
    };
  };
}