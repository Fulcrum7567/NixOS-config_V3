{ config, lib, ... }:
{
  options.server.services.vikunja = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Vikunja service.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Vikunja configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.services.vikunja.availableConfigs or []);
      default = "default";
      description = "The active Vikunja configuration.";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 3456;
      description = "Port for Vikunja web interface.";
    };

    defaultDataDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.server.system.filesystem.defaultDataDir}/vikunja";
      description = "Default directory to save Vikunja configurations.";
    };

    serviceUsername = lib.mkOption {
      type = lib.types.str;
      default = "vikunja";
      description = "System user to run the Vikunja service.";
    };

    serviceGroup = lib.mkOption {
      type = lib.types.str;
      default = "vikunja";
      description = "System group to run the Vikunja service.";
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "todo";
      description = "Subdomain for Vikunja service.";
    };

    timezone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Berlin";
      description = "Timezone for Vikunja service.";
    };

  };
}