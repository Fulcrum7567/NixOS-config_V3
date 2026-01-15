{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.reverseProxy.enable && (config.server.services.reverseProxy.activeConfig == "caddy")) {
    
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    
    services.caddy = {
      enable = config.server.services.reverseProxy.enable;
      virtualHosts = lib.mapAttrs' (name: value: lib.nameValuePair value.from {
        extraConfig = ''
          reverse_proxy http://${value.to}
        '';
      }) config.server.services.reverseProxy.activeRedirects;
    };
  };
}