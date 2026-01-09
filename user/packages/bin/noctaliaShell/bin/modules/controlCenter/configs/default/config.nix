{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.controlCenter.enable && (config.packages.noctaliaShell.modules.controlCenter.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        controlCenter = {
          position = "close_to_bar_button";
          diskPath = "/";
          shortcuts = {
            left = [
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "ScreenRecorder";
              }
              {
                id = "WallpaperSelector";
              }
            ];
            right = [
              {
                id = "Notifications";
              }
              {
                id = "PowerProfile";
              }
              {
                id = "KeepAwake";
              }
              {
                id = "NightLight";
              }
            ];
          };
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = false;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };
      };
    };
    
  };
}