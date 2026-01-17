{ config, lib, pkgs-default, ... }:
{
  config = lib.mkIf config.server.services.immich.enable {

    
    services.immich = {
      enable = true;
      user = "immich";
      group = lib.mkIf (config.services.immich.user == config.user.settings.username) "users";
      mediaLocation = config.server.services.immich.defaultDataDir;

      port = config.server.services.immich.port;

      accelerationDevices = null;
      
    };

    

    users.users.${config.services.immich.user}.extraGroups = [ "video" "render" ];

    
    # Make sure folder exists with correct permissions
    systemd.tmpfiles.rules = [
      "d ${config.server.services.immich.defaultDataDir} 0770 ${config.services.immich.user} ${config.services.immich.group} - -"
      "Z ${config.server.services.immich.defaultDataDir} 0770 ${config.services.immich.user} ${config.services.immich.group} - -"
    ];

    

    server.services.reverseProxy.activeRedirects."immich" = lib.mkIf config.server.services.immich.exposeGUI {
      subdomain = "immich";
      useACMEHost = true;
      forceSSL = true;

      locations."/" = {
        path = "/";
        to = "http://[::1]:${toString config.services.immich.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
        '';
      };
    };
  };
}