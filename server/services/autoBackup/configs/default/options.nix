{ config, lib, ... }:
{
  config.server.services.autoBackup.availableConfigs = [ "caddy" ];
}