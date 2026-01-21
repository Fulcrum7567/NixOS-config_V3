{ config, lib, ... }:
{
  options.server = {
    webaddress = lib.mkOption {
      type = lib.types.str;
      description = "The web address of the server.";
      example = "myserver.example.com";
    };

    dnsProvider = lib.mkOption {
      type = lib.types.str;
      default = "inwx";
      description = "The DNS provider used for ACME certificate generation.";
      example = "inwx";
    };

    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          displayName = lib.mkOption {
            type = lib.types.str;
            description = "The display name of the user.";
            example = "John Doe";
          };
          groups = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "users" ];
            description = "Additional groups for the user.";
            example = "[ \"nginx\" \"docker\" ]";
          };
          legalName = lib.mkOption {
            type = lib.types.str;
            description = "The legal name of the user.";
            example = "Johnathan A. Doe";
          };
          mailAddresses = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Email addresses associated with the user.";
            example = "[ \"john.doe@example.com\" ]";
          };
          present = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether the user should be present on the system.";
          };
        };
      });
      default = {
        "${config.user.settings.username}" = {
          displayName = config.user.settings.displayName;
          legalName = config.user.settings.displayName;
          mailAddresses = [ "dragon.fighter@outlook.de" ];
          groups = [ "all_services" ];
          present = true;
        };
      };
      description = "Attributes for system users.";
    };
  };
}