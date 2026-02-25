{ config, lib, ... }:
let
  cfg = config.server.services.mail-client;
  mailServerCfg = config.server.services.mail-server;
in
{
  config = lib.mkIf (cfg.enable && (cfg.activeConfig == "roundcube")) {
    services.roundcube = {
      enable = true;
      hostName = cfg.fullDomainName;
      extraConfig = ''
        $config['mail_domain'] = '${config.server.webaddress}';
        $config['imap_host'] = 'ssl://${mailServerCfg.fullDomainName}:993';
        $config['smtp_server'] = 'tls://${mailServerCfg.fullDomainName}';
        $config['smtp_port'] = 465;
      '';
    };

    # Add SSL/ACME to the nginx vhost that the Roundcube module creates.
    # Disable enableACME (set by the Roundcube module) since we use the
    # shared wildcard certificate via useACMEHost instead.
    services.nginx.virtualHosts.${cfg.fullDomainName} = {
      enableACME = lib.mkForce false;
      forceSSL = true;
      useACMEHost = config.server.webaddress;
    };
  };
}