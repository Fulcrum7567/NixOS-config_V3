{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.immich.enable && (config.server.services.immich.activeConfig == "default")) {
    
  };
    
}