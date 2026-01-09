{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.osd.enable && (config.packages.noctaliaShell.modules.osd.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        osd = {
          enabled = true;
          location = "top_right";
          autoHideMs = 2000;
          overlayLayer = true;
          backgroundOpacity = 1;
          enabledTypes = [
            0
            1
            2
          ];
          monitors = [ ];
        };
      };
    };
    
  };
}