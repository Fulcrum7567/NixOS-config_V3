{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.dock.enable && (config.packages.noctaliaShell.modules.dock.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        dock = {
          enabled = true;
          displayMode = "auto_hide";
          backgroundOpacity = 1;
          floatingRatio = 1;
          size = 1;
          onlySameOutput = true;
          monitors = [ ];
          pinnedApps = [ ];
          colorizeIcons = false;
          pinnedStatic = false;
          inactiveIndicators = false;
          deadOpacity = 0.6;
          animationSpeed = 1;
        };
      };
    };
    
  };
}