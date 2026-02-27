{ config, lib, pkgs, ... }:
{
  options.server.services.nextcloud = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the Nextcloud service.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nextcloud32;
      description = "The Nextcloud package to use. Must be incremented by 1 for major upgrades.";
    };

    defaultDataDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.server.system.filesystem.defaultDataDir}/nextcloud";
      description = "The default data directory for Nextcloud (stored on /data partition for easy backup).";
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

    maxUploadSize = lib.mkOption {
      type = lib.types.str;
      default = "10G";
      description = "Maximum upload file size for Nextcloud.";
    };

    serviceUsername = lib.mkOption {
      type = lib.types.str;
      default = "nextcloud";
      description = "System user to run the Nextcloud service.";
    };

    serviceGroup = lib.mkOption {
      type = lib.types.str;
      default = "nextcloud";
      description = "System group to run the Nextcloud service.";
    };

    extraApps = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = { };
      description = "Additional Nextcloud apps to install declaratively.";
    };

    disabledApps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of bundled Nextcloud app IDs to disable on every deploy.";
      example = [ "calendar" "contacts" "photos" "firstrunwizard" ];
    };
  };
}