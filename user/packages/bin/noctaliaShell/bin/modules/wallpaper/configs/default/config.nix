{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.wallpaper.enable && (config.packages.noctaliaShell.modules.wallpaper.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        wallpaper = {
          enabled = true;
          overviewEnabled = false;
          directory = "";
          monitorDirectories = [ ];
          enableMultiMonitorDirectories = false;
          recursiveSearch = false;
          setWallpaperOnAllMonitors = true;
          fillMode = "crop";
          fillColor = "#000000";
          useSolidColor = false;
          solidColor = "#1a1a2e";
          randomEnabled = false;
          wallpaperChangeMode = "random";
          randomIntervalSec = 300;
          transitionDuration = 1500;
          transitionType = "random";
          transitionEdgeSmoothness = 0.05;
          panelPosition = "follow_bar";
          hideWallpaperFilenames = false;
          useWallhaven = false;
          wallhavenQuery = "";
          wallhavenSorting = "relevance";
          wallhavenOrder = "desc";
          wallhavenCategories = "111";
          wallhavenPurity = "100";
          wallhavenRatios = "";
          wallhavenApiKey = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenResolutionHeight = "";
        };
      };
    };
    
  };
}