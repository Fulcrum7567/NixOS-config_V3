{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.syncthing.enable && (config.server.services.syncthing.activeConfig == "default")) {
    
  };
    
}