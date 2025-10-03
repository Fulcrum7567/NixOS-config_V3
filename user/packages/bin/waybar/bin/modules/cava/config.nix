{ config, lib, ... }:
{
  config = lib.mkIf (config.packages.waybar.modules.cava.enable) {
    packages.cava.enable = true;
  };
}