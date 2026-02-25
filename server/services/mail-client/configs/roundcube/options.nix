{ config, lib, ... }:
{
  config.server.services.mail-client.availableConfigs = [ "roundcube" ];
}