{ config, lib, ... }:
{
  config.server.services.forgejo.availableConfigs = [ "default" ];
}
