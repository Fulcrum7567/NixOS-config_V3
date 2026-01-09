{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.noctaliaShell.modules.network.enable && (config.packages.noctaliaShell.modules.network.activeConfig == "default")) {
    
    home-manager.users.${config.user.settings.username}= {
      programs.noctalia-shell.settings = {
        network = {
          wifiEnabled = true;
          bluetoothRssiPollingEnabled = false;
          bluetoothRssiPollIntervalMs = 10000;
          wifiDetailsViewMode = "grid";
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
        };
      };
    };
    
  };
}