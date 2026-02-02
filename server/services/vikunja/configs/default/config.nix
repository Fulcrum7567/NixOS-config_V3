{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.vikunja.enable && (config.server.services.vikunja.activeConfig == "default")) {
    
  };
    
}