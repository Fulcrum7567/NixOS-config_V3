{ config, lib, ... }:
{
  config.server.services.singleSignOn.availableConfigs = [ "kanidm" ];

  options.server.services.singleSignOn.kanidm = {
    customStyling = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable custom styling for Kanidm SSO login pages.";
      };

      favicon = lib.mkOption {
        type = lib.types.path;
        default = ../../bin/icons/lockPerson.svg;
        description = "Path to the favicon for Kanidm SSO pages.";
      };
    };
  };
}