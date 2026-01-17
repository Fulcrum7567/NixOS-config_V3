{ config, lib, ... }:
{
  config.server.services.singleSignOn.availableConfigs = [ "kanidm" ];
}