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

        interval = lib.mkOption {
            type = lib.types.str;
            default = "daily";
            description = "How often automatic updates should run";
        };

        enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to enable the ${settings.displayName} component.";
        };

    };
}