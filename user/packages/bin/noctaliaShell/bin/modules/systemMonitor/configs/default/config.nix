{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.systemMonitor.enable && (config.packages.noctaliaShell.modules.systemMonitor.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        systemMonitor = {
          cpuWarningThreshold = 80;
          cpuCriticalThreshold = 90;
          tempWarningThreshold = 80;
          tempCriticalThreshold = 90;
          gpuWarningThreshold = 80;
          gpuCriticalThreshold = 90;
          memWarningThreshold = 80;
          memCriticalThreshold = 90;
          diskWarningThreshold = 80;
          diskCriticalThreshold = 90;
          cpuPollingInterval = 3000;
          tempPollingInterval = 3000;
          gpuPollingInterval = 3000;
          enableDgpuMonitoring = false;
          memPollingInterval = 3000;
          diskPollingInterval = 3000;
          networkPollingInterval = 3000;
          loadAvgPollingInterval = 3000;
          useCustomColors = false;
          warningColor = "";
          criticalColor = "";
          externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        };
      };
    };
    
  };
}