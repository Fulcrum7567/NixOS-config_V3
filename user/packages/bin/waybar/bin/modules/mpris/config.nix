{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.mpris.enable) {
    packages.mpris.enable = true;
  };
}