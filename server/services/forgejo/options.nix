{ config, lib, ... }:
{
  options.server.services.forgejo = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Forgejo git forge service.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Forgejo configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.services.forgejo.availableConfigs or []);
      default = "default";
      description = "The active Forgejo configuration.";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 3000;
      description = "Port for Forgejo web interface.";
    };

    defaultDataDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/forgejo"; # todo
      description = "Default directory to store Forgejo data.";
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "git";
      description = "Subdomain for the Forgejo service.";
    };

    serviceUsername = lib.mkOption {
      type = lib.types.str;
      default = "forgejo";
      description = "System user to run the Forgejo service.";
    };

    serviceGroup = lib.mkOption {
      type = lib.types.str;
      default = "forgejo";
      description = "System group to run the Forgejo service.";
    };

    exposeGUI = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Expose Forgejo web GUI via reverse proxy.";
    };

    lfsEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Git LFS support.";
    };
  };
}
