{ config, lib, pkgs-default, ... }:
{
  config = lib.mkIf config.server.services.immich.enable {

    
    services.immich = {
      enable = true;
      user = "immich"; #config.user.settings.username;
      group = lib.mkIf (config.services.immich.user == config.user.settings.username) "users";
      mediaLocation = config.server.services.immich.defaultDataDir;

      openFirewall = true;

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
        to = "http://127.0.0.1:${toString config.server.services.immich.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
        '';
      };
    };
  };
}