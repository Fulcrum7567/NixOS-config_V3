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
            default = "RX500Series";
            description = "Set the active configuration for the ${settings.displayName} component.";
        };

        enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to enable the ${settings.displayName} component.";
        };

    };
}
