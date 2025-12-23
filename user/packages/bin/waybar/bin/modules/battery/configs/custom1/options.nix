{ config, lib, ... }:
{
  config.packages.waybar.modules.battery.availableConfigs = [ "custom1" ];
}