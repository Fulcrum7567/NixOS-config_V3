{ config, lib, ... }:
{
  options.server.services.singleSignOn = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = (config.host.settings.systemType == "server");
      description = "Enable the single sign-on service.";
    };
    
    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of available single sign-on configurations.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.server.services.singleSignOn.availableConfigs or []);
      default = "kanidm";
      description = "The active single sign-on configuration.";
    };

    serviceUsername = lib.mkOption {
      type = lib.types.str;
      default = config.server.services.singleSignOn.activeConfig;
      description = "The system username under which the single sign-on service runs.";
    };

    serviceGroup = lib.mkOption {
      type = lib.types.str;
      default = config.server.services.singleSignOn.serviceUsername;
      description = "The system group under which the single sign-on service runs.";
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "sso";
      description = "The subdomain to use for the single sign-on service.";
    };

    fullDomainName = lib.mkOption {
      type = lib.types.str;
      default = "${config.server.services.singleSignOn.subdomain}.${config.server.webaddress}";
      description = "The full domain name to access the single sign-on service.";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8443;
      description = "The port for the single sign-on service.";
    };

    domainIcon = lib.mkOption {
      type = lib.types.path;
      default = ./bin/icons/passkey.svg;
      description = "Path to an image file (e.g., logo) for the single sign-on service.";
    };

    oAuthServices = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          displayName = lib.mkOption {
            type = lib.types.str;
            description = "The display name for this OAuth service.";
          };
          originUrl = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "The origin URL(s) for this OAuth service.";
          };
          originLanding = lib.mkOption {
            type = lib.types.str;
            description = "The landing page URL after OAuth authentication.";
          };
          basicSecretFile = lib.mkOption {
            type = lib.types.path;
            description = "Path to the file containing the basic secret for this OAuth service.";
          };
          imageFile = lib.mkOption {
            type = lib.types.path;
            default = ./bin/icons/sso.svg;
            description = "Path to an image file (e.g., logo) for this OAuth service.";
          };
          preferShortUsername = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to prefer short usernames for this OAuth service. Sends myuser instead of myuser@example.com.";
          };

          groupName = lib.mkOption {
            type = lib.types.str;
            description = "The group name to assign to users authenticated via this OAuth service.";
          };

          scopes = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "The OAuth scopes to request for this service.";
          };

          allowInsecureClientDisablePkce = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Allow this OAuth client to skip PKCE. Only enable for legacy clients that don't support PKCE.";
          };
        };      
      });
      default = { };
    };
  };
}