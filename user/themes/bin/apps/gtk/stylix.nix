{ config, lib, ... }:
{
  config = lib.mkIf (config.theming.gtk.useStylix) {
    stylix.targets.gtk.enable = true;
  };
}