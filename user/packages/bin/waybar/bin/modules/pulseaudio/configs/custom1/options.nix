{ config, lib, ... }:
{
  config.packages.waybar.modules.pulseaudio.availableConfigs = [ "custom1" ];
}