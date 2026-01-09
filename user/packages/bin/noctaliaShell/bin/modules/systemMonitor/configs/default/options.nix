{ config, lib, ... }:
{
  config.packages.noctaliaShell.modules.systemMonitor.availableConfigs = [ "default" ];
}