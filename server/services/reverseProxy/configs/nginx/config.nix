{ config, lib, ... }:
{
  config = lib.mkIf (config.server.services.reverseProxy.enable && (config.server.services.reverseProxy.activeConfig == "nginx")) {
    
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    sops.secrets.inwx_credentials = {
      owner = "acme";
      sopsFile = ./inwxSecrets.yaml;
      format = "yaml";
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

          proxyWebsockets = true;
          extraConfig = ''
            proxy_read_timeout 600s;
          
            # 1. Wir sagen Syncthing: "Ich bin localhost:8384"
            proxy_set_header Host 127.0.0.1:8384;
            
            # 2. WICHTIG: Wir fälschen auch den Ursprung, damit der CSRF-Schutz nicht greift!
            # Syncthing denkt, der Request kommt von seiner eigenen GUI.
            proxy_set_header Origin http://127.0.0.1:8384;
            proxy_set_header Referer http://127.0.0.1:8384;

            # 3. IP-Weiterleitung für Logging (optional, aber gut)
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
    
  };
}