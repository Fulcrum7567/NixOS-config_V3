{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.reverseProxy.enable && (config.server.services.reverseProxy.activeConfig == "caddy")) {
    
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    
    services.caddy = {
      enable = config.server.services.reverseProxy.enable;

      /*
      virtualHosts = lib.mapAttrs' (name: value: lib.nameValuePair value.from {
        extraConfig = ''
          reverse_proxy http://${value.to}
        '';
      }) config.server.services.reverseProxy.activeRedirects;
      */

      virtualHosts."syncthing.aurek.eu" = {
        extraConfig = ''
          # Proxy to the local Syncthing GUI
          reverse_proxy http://127.0.0.1:8384 {
              # Syncthing sometimes requires the Host header to match. 
              # Caddy passes this by default, but we ensure transparency.
              header_up Host {host}
          }
        '';
      };
    };
  };
}