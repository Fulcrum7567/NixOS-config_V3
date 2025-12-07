{ config, lib, disko, ... }:
{
  imports = [
    disko.nixosModules.disko
  ];

  config.system = lib.mkIf (config.server.system.filesystem.disko.enable) {
    inputUpdates = [ "disko-stable" "disko-unstable" ];
  };
}