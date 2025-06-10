{ config, lib, settings, ... }:
{
  options.hosts.components.${settings.optionName} = {

    availableConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      apply = x: lib.unique x;
      description = "List of all available configs for the ${settings.displayName} component.";
    };

    activeConfig = lib.mkOption {
      type = lib.types.enum (config.hosts.components.${settings.optionName}.availableConfigs or []);
      default = "default";
      description = "Set the active configuration for the ${settings.displayName} component.";
    };

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the ${settings.displayName} component.";
    };

    # Declare the interface option, allowing it to be null
    interface = lib.mkOption {
      type = lib.types.nullOr lib.types.str; # It can be a string or null
      default = null; # Explicitly default to null
      description = "Lan interface of your host. Check with ip a";
    };
  };

  # Now, in the config section, add the assertion
  config = lib.mkIf config.hosts.components.${settings.optionName}.enable {
    # We assert that 'interface' is not null IF 'enable' is true.
    # This assertion applies to the final *evaluated* config.
    assertions = [
      {
        assertion = config.hosts.components.${settings.optionName}.interface != null;
        message = "The 'hosts.components.${settings.optionName}.interface' option must be set when 'hosts.components.${settings.optionName}.enable' is true.";
      }
    ];
  };
}