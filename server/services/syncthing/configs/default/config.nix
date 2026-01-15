{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.syncthing.enable && (config.server.services.syncthing.activeConfig == "default")) {
    services.syncthing = {
      settings = {
        
        folders = {
          "FH" = {
            path = "${config.server.services.syncthing.defaultDataDir}/FH";
            devices = [ "PET" "Hyprdrive" ];
          };
        };
      };

    };
  };
    
}