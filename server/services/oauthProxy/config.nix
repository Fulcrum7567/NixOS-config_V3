{ config, lib, pkgs-default, ... }:
let
  cfg = config.server.services.oauthProxy;
in
{
  config = lib.mkIf cfg.enable {

    systemd.services = mapAttrs' (name: serviceCfg: 
      let
        # Helper to convert list to repeated config lines if necessary, 
        # but oauth2-proxy config file format often takes commas for lists 
        # or multiple keys. We will construct a config file.
        
        # We transform the configuration options into a string format 
        # accepted by oauth2-proxy config file (key = value)
        
        mkConf = k: v: "${k} = \"${toString v}\"";
        
        mainConfig = ''
          provider = "${serviceCfg.provider}"
          client_id = "${serviceCfg.clientID}"
          http_address = "${serviceCfg.httpAddress}"
          oidc_issuer_url = "${serviceCfg.oidcIssuerUrl}"
          client_secret_file = "${serviceCfg.clientSecretFile}"
          cookie_secret_file = "${serviceCfg.cookieSecretFile}"
          email_domains = [ ${concatMapStringsSep ", " (d: "\"${d}\"") serviceCfg.emailDomains} ]
          upstreams = [ ${concatMapStringsSep ", " (u: "\"${u}\"") serviceCfg.upstream} ]
        '';

        extraConfig = concatStringsSep "\n" 
          (mapAttrsToList mkConf serviceCfg.extraConfig);
          
        configFile = pkgs-default.writeText "oauth2-proxy-${name}.cfg" ''
          ${mainConfig}
          ${extraConfig}
        '';

      in nameValuePair "oauth2-proxy-${name}" {
        description = "OAuth2 Proxy for ${name}";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        
        serviceConfig = {
          ExecStart = "${pkgs-default.oauth2-proxy}/bin/oauth2-proxy --config ${configFile}";
          Restart = "always";
          
          # Security hardening (optional but recommended)
          User = "root";
          # If your secrets are in /run/secrets (sops-nix), the dynamic user needs access.
          # Option A: Run as root (simplest for secrets, less secure)
          # Option B: Use LoadCredential (advanced)
          # Option C: Add the user to the secrets group if sops-nix is configured that way
          # For this example, we'll keep it simple. If sops permissions fail, 
          # you might need to set `User = "root"` or configure sops groups.
        };
      }
    ) cfg.services;
    
  };
}