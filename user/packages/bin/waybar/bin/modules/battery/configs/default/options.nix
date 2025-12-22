{ config, lib, ... }:
{
  config.packages.waybar.modules.battery.availableConfigs = [ "default" ];
}