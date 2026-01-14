{ config, lib, pkgs-default, ... }:
{
  config = lib.mkIf config.server.services.syncthing.enable {

    sops.secrets = {
      # The server's own identity (private key and cert)
      "syncthing/server/key" = { 
        owner = "syncthing"; 
        group = "syncthing";
        sopsFile = ./syncthingSecrets.yaml;
        format = "yaml";
        # Restart syncthing if these change
        restartUnits = [ "syncthing.service" ]; 
      };
      "syncthing/server/cert" = { 
        owner = "syncthing"; 
        group = "syncthing";
        sopsFile = ./syncthingSecrets.yaml;
        format = "yaml";
        restartUnits = [ "syncthing.service" ];
      };
    };

    services.syncthing = {
      enable = true;
      openDefaultPorts = true;

      user = "syncthing";
      group = "syncthing";
      dataDir = "${config.server.services.syncthing.defaultSaveDir}";
      configDir = "${config.server.filesystem.defaultConfigDir}/syncthing";

      key = config.sops.secrets."syncthing/server/key".path;
      cert = config.sops.secrets."syncthing/server/cert".path;
      
      overrideDevices = true;
      overrideFolders = true;

      settings = {

        gui = {
          user = config.user.settings.username;
          theme = if ((config.theming.polarity == "light") then "light" else "dark");
          password = "$2a$10$HWGHFG2AZN3m3bb3OUfyHOoTky57TeC8flop.HfkJqF5UMyD1ha82";
        };

        devices = {
          /*
          "PET" = {
            id = ""
          };
          */
          "Hyprdrive" = {
            id = "6PW3EJM-HRKMYVQ-3OOORYX-7UV6OU2-EGVFUPO-FQOVLYY-IENKT2S-5IWGNQV";
          };
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 8384 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}