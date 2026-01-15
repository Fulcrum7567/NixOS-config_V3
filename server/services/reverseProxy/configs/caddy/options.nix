{ config, lib, ... }:
{
  config.server.services.reverseProxy.availableConfigs = [ "caddy" ];
}