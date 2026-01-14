{ config, lib, ... }:
{
  options.server.system.filesystem = {
    defaultDataDir = lib.mkOption {
      type = lib.types.str;
      default = "/data";
      description = "Default data directory for services and apps.";
    };

    defaultConfigDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.user.settings.username}/.config";
      description = "Default configuration directory for services and apps.";
    };
  };
}