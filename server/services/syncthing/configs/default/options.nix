{ config, lib, ... }:
{
  config.server.services.syncthing.availableConfigs = [ "default" ];
}