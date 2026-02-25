{ config, lib, ... }:
{
  options.server.services.mail-server = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Email service.";
    };

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available Email configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.services.mail-server.availableConfigs or []);
      default = "stalwart";
      description = "The active Email configuration.";
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "stalwart";
      description = "The subdomain to host the Email service on.";
    };

    fullDomainName = lib.mkOption {
      type = lib.types.str;
      default = "${config.server.services.mail-server.subdomain}.${config.server.webaddress}";
      description = "The full domain name to access the Email service.";
    };

    fullHttpsUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://${config.server.services.mail-server.fullDomainName}";
      description = "The full HTTPS URL to access the Email service.";
    };

  };
}