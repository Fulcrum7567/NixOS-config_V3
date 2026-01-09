{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.audio.enable && (config.packages.noctaliaShell.modules.audio.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        audio = {
          volumeStep = 5;
          volumeOverdrive = false;
          cavaFrameRate = 30;
          visualizerType = "linear";
          mprisBlacklist = [ ];
          preferredPlayer = "";
          externalMixer = "pwvucontrol || pavucontrol";
        };
      };
    };
    
  };
}