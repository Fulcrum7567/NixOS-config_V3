{ config, lib, ... }:
let
  cfg = config.server.services.mail-client;
in
{
  config = lib.mkIf (cfg.enable && (cfg.activeConfig == "roundcube")) {
    services.roundcube = {
      enable = true;
      domain = cfg.fullDomainName;
      extraConfig = ''
        $config['mail_domain'] = '${cfg.fullDomainName}';
        $config['smtp_server'] = 'tls://localhost';
        $config['smtp_port'] = 587;
      '';
    };
  };
}