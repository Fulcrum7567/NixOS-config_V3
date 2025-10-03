{ config, lib, ... }:
{
  config = lib.mkIf config.packages.waybar.modules.pulseaudio.enable {
    packages.pavucontrol.enable = true;
  };
}