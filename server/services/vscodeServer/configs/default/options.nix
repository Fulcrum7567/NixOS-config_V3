{ config, lib, ... }:
{
  config.server.services.vscodeServer.availableConfigs = [ "default" ];
}