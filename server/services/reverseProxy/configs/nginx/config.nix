{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.reverseProxy.enable && (config.server.services.reverseProxy.activeConfig == "nginx")) {
    
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    sops.secrets.inwx_credentials = {
      owner = "acme";
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "dragon.fighter@outlook.de";

      certs."${config.server.webaddress}" = {
        domain = "*.${config.server.webaddress}";
        # Optional: Auch die Hauptdomain selbst zertifizieren
        extraDomainNames = [ "${config.server.webaddress}" ];
        
        # WICHTIG: DNS Challenge nutzen
        dnsProvider = config.server.dnsProvider;
        
        # Pfad zu den Credentials aus sops
        credentialsFile = config.sops.secrets.inwx_credentials.path;
        
        # Nginx muss Zugriff auf die generierten Zertifikate haben
        group = "nginx";
      };
    };  

    services.nginx = {
      enable = true;

      # Sicherheitsempfehlungen und Gzip aktivieren
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."syncthing.${config.server.webaddress}" = {
        forceSSL = true;
        useACMEHost = config.server.webaddress; 

        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
        };
      };  
    
  };
}