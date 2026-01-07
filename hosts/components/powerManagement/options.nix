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
            default = "ppd";
            description = "Set the active configuration for the ${settings.displayName} component.";
        };

        enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to enable the ${settings.displayName} component.";
        };

        autoSwitchProfiles = lib.mkOption {
            type = lib.types.bool;
            default = (config.host.settings.systemType == "laptop");
            description = "Automatically switch power profiles based on power source (AC/Battery).";
        };

        chargeLimit = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = if (config.host.settings.systemType == "laptop") then 85 else null;
            description = "Set the battery charge limit percentage for power management.";
        };

        limitWattageOnBattery = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Limit power consumption when running on battery to prevent crashes on faulty batteries.";
        };


    };
}
