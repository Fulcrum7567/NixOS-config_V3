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

      "syncthing/oauth/client_secret" = {
        owner = config.server.services.singleSignOn.serviceUsername;
        group = config.server.services.singleSignOn.serviceGroup;
        sopsFile = ./syncthingSecrets.yaml;
        format = "yaml";
        key = "syncthing_oauth_client_secret";
        restartUnits = [ "kanidm.service" ];
        mode = "0440";
      };

      "syncthing/oauth/proxy_client_secret" = {
        owner = "oauth2-proxy";
        group = "oauth2-proxy";
        sopsFile = ./syncthingSecrets.yaml;
        format = "yaml";
        key = "syncthing_oauth_client_secret";
        restartUnits = [ "oauth2-proxy.service" ];
      };

      "syncthing/oauth/proxy_cookie_secret" = {
        owner = "oauth2-proxy";
        group = "oauth2-proxy";
        sopsFile = ./syncthingSecrets.yaml;
        format = "yaml";
        key = "syncthing_oauth_cookie_secret";
        restartUnits = [ "oauth2-proxy.service" ];
      };
    };

    services.syncthing = {
      enable = true;
      openDefaultPorts = false;

      user = config.user.settings.username;
      group = (if config.services.syncthing.user == config.user.settings.username then "users" else config.services.syncthing.group);
      dataDir = config.server.services.syncthing.defaultDataDir;
      configDir = "${config.server.system.filesystem.defaultConfigDir}/syncthing";

      guiAddress = "127.0.0.1:${toString config.server.services.syncthing.port}";

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
      "Z ${config.services.syncthing.configDir} 0700 ${config.services.syncthing.user} ${config.services.syncthing.group} - -"
      "d ${config.server.services.syncthing.defaultDataDir} 0770 ${config.services.syncthing.user} ${config.services.syncthing.group} - -"
      "Z ${config.server.services.syncthing.defaultDataDir} 0770 ${config.services.syncthing.user} ${config.services.syncthing.group} - -"
    ];

    systemd.services.syncthing = {

      wants = [ "sops-nix.service" ];
      # Wait for sops-nix to decrypt secrets
      after = [ "sops-nix.service" ];

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

    server.services.reverseProxy.activeRedirects."syncthing" = lib.mkIf config.server.services.syncthing.exposeGUI {
      subdomain = "syncthing";
      useACMEHost = true;
      forceSSL = true;

      locations."/" = {
        path = "/";
        to = "http://127.0.0.1:8385";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
        '';
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };

    services.oauth2-proxy = {
      enable = true;
      provider = "oidc";
      clientID = "syncthing";
      
      upstream = [ "http://127.0.0.1:${toString config.server.services.syncthing.port}" ];
      httpAddress = "127.0.0.1:8385";

      clientSecret = "";

      oidcIssuerUrl = "https://${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}/oauth2/openid/syncthing";
      email.domains = [ "*" ];
      
      extraConfig = {
        redirect-url = "https://syncthing.${config.server.webaddress}/oauth2/callback";
        client-secret-file = config.sops.secrets."syncthing/oauth/proxy_client_secret".path;
        cookie-secret-file = config.sops.secrets."syncthing/oauth/proxy_cookie_secret".path;
      
        pass-access-token = "true";
        pass-authorization-header = "true";
        set-xauthrequest = "true";
        # Optional: ensure we can handle long syncthing requests
        upstream-timeout = "600s";
      };
    };

    server.services.singleSignOn.oAuthServices."syncthing" = {
      displayName = "Syncthing";
      originUrl = [ "https://syncthing.${config.server.webaddress}/oauth2/callback" ];
      originLanding = "https://syncthing.${config.server.webaddress}";
      basicSecretFile = config.sops.secrets."syncthing/oauth/client_secret".path; 
      preferShortUsername = true;
      groupName = "syncthing-users";
      scopes = [ "openid" "profile" "email" ];
    };
  };
}