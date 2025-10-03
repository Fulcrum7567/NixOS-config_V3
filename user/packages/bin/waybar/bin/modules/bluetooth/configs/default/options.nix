{ config, lib, ... }:
{
  config.packages.waybar.modules.bluetooth.availableConfigs = [ "default" ];
}