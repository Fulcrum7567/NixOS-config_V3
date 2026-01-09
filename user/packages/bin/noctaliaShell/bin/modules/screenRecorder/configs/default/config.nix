{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.screenRecorder.enable && (config.packages.noctaliaShell.modules.screenRecorder.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        screenRecorder = {
          directory = "";
          frameRate = 60;
          audioCodec = "opus";
          videoCodec = "h264";
          quality = "very_high";
          colorRange = "limited";
          showCursor = true;
          copyToClipboard = false;
          audioSource = "default_output";
          videoSource = "portal";
        };
      };
    };
    
  };
}