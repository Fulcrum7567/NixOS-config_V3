{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.notifications.enable && (config.packages.noctaliaShell.modules.notifications.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        notifications = {
          enabled = true;
          monitors = [ ];
          location = "top_right";
          overlayLayer = true;
          backgroundOpacity = 1;
          respectExpireTimeout = false;
          lowUrgencyDuration = 3;
          normalUrgencyDuration = 8;
          criticalUrgencyDuration = 15;
          enableKeyboardLayoutToast = true;
          saveToHistory = {
            low = true;
            normal = true;
            critical = true;
          };
          sounds = {
            enabled = false;
            volume = 0.5;
            separateSounds = false;
            criticalSoundFile = "";
            normalSoundFile = "";
            lowSoundFile = "";
            excludedApps = "discord,firefox,chrome,chromium,edge";
          };
        };
      };
    };
    
  };
}