{ config, lib, ... }:
{
  config.packages.waybar.modules.network.availableConfigs = [ "default" ];
}