{ config, lib, ... }:
let
  cfg = config.server.services.mail-client;
  domain = config.server.webaddress;
in
{
  config = lib.mkIf (cfg.enable && (cfg.activeConfig == "roundcube")) {

    # ── Roundcube Service ─────────────────────────────────────────────────
    services.roundcube = {
      enable = true;
      hostName = cfg.fullDomainName;
      database = {
        host = "localhost";
        dbname = "roundcube";
        username = "roundcube";
      };
      extraConfig = ''
        $config['mail_domain'] = '${domain}';
        $config['imap_host'] = 'ssl://localhost:993';
        $config['smtp_host'] = 'ssl://localhost:465';
        $config['use_https'] = true;

        // Accept the server's TLS cert even though we connect via "localhost"
        // while the cert is issued for *.${domain}
        $config['imap_conn_options'] = [
          'ssl' => ['verify_peer' => false, 'verify_peer_name' => false],
        ];
        $config['smtp_conn_options'] = [
          'ssl' => ['verify_peer' => false, 'verify_peer_name' => false],
        ];
      '';
    };

    # ── Nginx SSL/ACME ────────────────────────────────────────────────────
    # Disable enableACME (set by the Roundcube module) since we use the
    # shared wildcard certificate via useACMEHost instead.
    services.nginx.virtualHosts.${cfg.fullDomainName} = {
      enableACME = lib.mkForce false;
      forceSSL = true;
      useACMEHost = domain;
    };
  };
}