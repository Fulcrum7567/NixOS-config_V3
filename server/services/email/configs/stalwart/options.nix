{ config, lib, ... }:
{
  config.server.services.mail-server.availableConfigs = [ "stalwart" ];
}