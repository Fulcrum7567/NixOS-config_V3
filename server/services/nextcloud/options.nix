{ config, lib, ... }:
{
  options.server.services.nextcloud = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the Nextcloud service";
    };

    defaultDataDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.server.system.filesystem.defaultDataDir}/nextcloud";
      description = "The default data directory for Nextcloud";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8085;
      description = "Port for the Nextcloud web interface (used internally by nginx upstream).";
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "cloud";
      description = "Subdomain for the Nextcloud service.";
    };

    exposeGUI = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Expose the Nextcloud web GUI via reverse proxy.";
    };

    adminUsername = lib.mkOption {
      type = lib.types.str;
      default = config.user.settings.username;
      description = "The admin username for Nextcloud.";
    };
  };
}