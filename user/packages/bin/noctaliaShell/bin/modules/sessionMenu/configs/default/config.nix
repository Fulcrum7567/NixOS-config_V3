{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.sessionMenu.enable && (config.packages.noctaliaShell.modules.sessionMenu.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
                sessionMenu = {
          enableCountdown = true;
          countdownDuration = 10000;
          position = "center";
          showHeader = true;
          largeButtonsStyle = false;
          largeButtonsLayout = "grid";
          showNumberLabels = true;
          powerOptions = [
            {
              action = "lock";
              enabled = true;
            }
            {
              action = "suspend";
              enabled = true;
            }
            {
              action = "hibernate";
              enabled = true;
            }
            {
              action = "reboot";
              enabled = true;
            }
            {
              action = "logout";
              enabled = true;
            }
            {
              action = "shutdown";
              enabled = true;
            }
          ];
        };
      };
    };
    
  };
}