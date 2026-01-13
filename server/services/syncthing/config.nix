{ config, lib, ... }:
{
  config = lib.mkIf config.server.services.syncthing.enable {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
    };

    networking.firewall.allowedTCPPorts = [ 8384 ];
  };
}