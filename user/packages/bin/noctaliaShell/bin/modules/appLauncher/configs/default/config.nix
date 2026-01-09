{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.appLauncher.enable && (config.packages.noctaliaShell.modules.appLauncher.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        appLauncher = {
          enableClipboardHistory = true;
          autoPasteClipboard = true;
          enableClipPreview = true;
          position = "center";
          pinnedApps = [ ];
          useApp2Unit = false;
          sortByMostUsed = true;
          terminalCommand = "xterm -e";
          customLaunchPrefixEnabled = false;
          customLaunchPrefix = "";
          viewMode = "list";
          showCategories = true;
          iconMode = "tabler";
          showIconBackground = false;
          ignoreMouseInput = false;
          screenshotAnnotationTool = "";
        };
      };
    };
    
  };
}