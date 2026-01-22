{ config, lib, ... }:
{
  config.server.services.email.availableConfigs = [ "stalwart" ];
}