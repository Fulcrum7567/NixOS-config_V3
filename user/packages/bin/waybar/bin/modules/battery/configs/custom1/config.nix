{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.battery.enable && (config.packages.waybar.modules.battery.activeConfig == "custom1")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      battery = {
        interval = 20;
        states = {
            warning = 30;
            critical = 15;
        };
        format = "<span size='250%' rise='-3500'>{icon}</span>";
        format-icons = ["" "" "" "" ""];


        format-warning = "<span size='250%' rise='-3500'>{icon}</span> {capacity}%";
        format-critical = "<span size='250%' rise='-3500'>{icon}</span> {capacity}%";
        format-charging = "<span size='250%' rise='-3500'>{icon}</span>";

        tooltip-format = "{capacity}%\nTime left: {time}";
        max-length = 25;
      };
    };
  };
}