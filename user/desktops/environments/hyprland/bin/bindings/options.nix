{ config, lib, ... }:
{
  options.desktopEnvironments.hyprland.bin.bindings = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable bindings for Hyprland.";
    };
  };
}