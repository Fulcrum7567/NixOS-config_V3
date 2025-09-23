{ config, lib, ... }:
{
  config = lib.mkIf config.theming.plymouth.enable {
    boot.plymouth.enable = true;
  };
}