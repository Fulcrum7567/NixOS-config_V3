{ config, lib, ... }:
{
  config.server.filesystem.availableConfigs = [ "zfs" ];
}