{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.syncthing.enable && (config.server.services.syncthing.activeConfig == "default")) {
    services.syncthing = {
      settings = {
        
        folders = {
          "Obsidian/FH" = {
            path = "${config.server.services.syncthing.defaultDataDir}/obsidian/FH";
            devices = [ "PET" "Hyprdrive" ];
          };
        };
      };

    };
  };
    
}