{ config, lib, pkgs-default, ... }:
{
  config = lib.mkIf config.server.services.syncthing.enable {

    sops.secrets = {
      # The server's own identity (private key and cert)
      "syncthing/server/key" = { 
        owner = config.services.syncthing.user; 
        group = config.services.syncthing.group;
        sopsFile = ./syncthingSecrets.yaml;
        format = "yaml";
        key = "syncthing/key";
        restartUnits = [ "syncthing.service" ]; 
      };
      "syncthing/server/cert" = { 
        owner = config.services.syncthing.user; 
        group = config.services.syncthing.group;
        sopsFile = ./syncthingSecrets.yaml;
        format = "yaml";
        key = "syncthing/cert";
        restartUnits = [ "syncthing.service" ];
      };
    };

    services.syncthing = {
      enable = true;
      openDefaultPorts = false;

      user = config.user.settings.username;
      dataDir = config.server.services.syncthing.defaultDataDir;
      configDir = "${config.server.system.filesystem.defaultConfigDir}/syncthing";

      guiAddress = "0.0.0.0:8384";

      key = config.sops.secrets."syncthing/server/key".path;
      cert = config.sops.secrets."syncthing/server/cert".path;
      
      overrideDevices = true;
      overrideFolders = true;

      settings = {

        gui = {
          user = config.user.settings.username;
          theme = (if (config.theming.polarity == "light") then "light" else "dark");
          password = "$2a$10$HWGHFG2AZN3m3bb3OUfyHOoTky57TeC8flop.HfkJqF5UMyD1ha82";

          insecureSkipHostcheck = true;
        };

        devices = {
          
          "PET" = {
            id = "RW4U4RS-26NEMOV-SFJBHKY-YBOJGOV-TTUPILL-W3IFLFT-Y2MWGXC-CR44HQ3";
          };
          
          "Hyprdrive" = {
            id = "6PW3EJM-HRKMYVQ-3OOORYX-7UV6OU2-EGVFUPO-FQOVLYY-IENKT2S-5IWGNQV";
          };
        };
      };
    };

    # Make sure folder exists with correct permissions
    systemd.tmpfiles.rules = [
      "d ${config.services.syncthing.configDir} 0700 ${config.services.syncthing.user} ${config.services.syncthing.group} - -"
      "Z ${config.server.services.syncthing.defaultDataDir} 0770 ${config.services.syncthing.user} ${config.services.syncthing.group} - -"
    ];

    systemd.services.syncthing = {
      unitConfig = {
        RequiresMountsFor = [ 
          "${config.server.services.syncthing.defaultDataDir}"
          "${config.services.syncthing.configDir}"
        ];
      };
      serviceConfig = {
        # This allows the service to write to your custom ZFS mount
        ReadWritePaths = [ 
          "${config.server.services.syncthing.defaultDataDir}/" 
          "${config.services.syncthing.configDir}/"
        ];
      };
    };

    server.services.reverseProxy.activeRedirects."syncthing" = {
      from = "syncthing.${config.server.webaddress}";
      useACMEHost = true;
      forceSSL = true;

      locations."/" = {
        path = "/";
        to = "http://127.0.0.1:8384";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
        '';
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 8384 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}