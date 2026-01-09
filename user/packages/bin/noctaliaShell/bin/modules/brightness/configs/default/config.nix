{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.brightness.enable && (config.packages.noctaliaShell.modules.brightness.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        brightness = {
          brightnessStep = 5;
          enforceMinimum = true;
          enableDdcSupport = false;
        };
      };
    };
    
  };
}