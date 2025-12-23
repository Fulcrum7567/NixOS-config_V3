{ config, lib, ... }:
{
  config.packages.waybar.modules.network.availableConfigs = [ "custom1" ];
}