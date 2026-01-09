{ config, lib, ... }:
{
  config.packages.noctaliaShell.modules.network.availableConfigs = [ "default" ];
}