{ config, lib, disko, ... }:
{
  imports = [
    disko.nixosModules.disko
  ];

  config = lib.mkIf (config.server.system.filesystem.disko.enable) {
    networking.hostId = "63363231"; # Generate one via: head -c 4 /etc/machine-id | od -A n -t x4
    
    system = {
      inputUpdates = [ "disko-stable" "disko-unstable" ];
    };
  };
}