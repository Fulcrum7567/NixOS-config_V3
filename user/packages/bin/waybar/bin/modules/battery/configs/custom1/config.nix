{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.battery.enable && (config.packages.waybar.modules.battery.activeConfig == "custom1")) {
    home-manager.users.${config.user.settings.username}.programs.waybar.settings.mainBar = {
      battery = {
        interval = 3;
        states = {
            warning = 30;
            critical = 15;
        };
        format = "<span size='250%'>{icon}</span>";
        format-icons = ["" "" "" "" ""];

        
        format-warning = "<span size='250%'>{icon}</span> <span rise='7800'>{capacity}%</span>";
        format-critical = "<span size='250%'>{icon}</span> <span rise='7800'>{capacity}%</span>";
        format-charging = "<span size='150%' rise='4000'></span><span size='250%'>{icon}</span>";
        

        tooltip-format = "{capacity}%\nTime left: {time}";
        max-length = 25;
      };
    };
  };
}