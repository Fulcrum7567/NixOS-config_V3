{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.calendar.enable && (config.packages.noctaliaShell.modules.calendar.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        calendar = {
          cards = [
            {
              enabled = true;
              id = "calendar-header-card";
            }
            {
              enabled = true;
              id = "calendar-month-card";
            }
            {
              enabled = true;
              id = "timer-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
          ];
        };
      };
    };
    
  };
}