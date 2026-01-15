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
			default = "default"; # A default config should always exist, delete if not
			description = "Set the active configuration for the ${settings.displayName} component.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the ${settings.displayName} component.";
		};

		shutdownAt = lib.mkOption {
			type = lib.types.str;
			default = "22:00";
			description = "Time to shutdown the system (24h format HH:MM).";
		};

		wakeUpAt = lib.mkOption {
			type = lib.types.str;
			default = "06:00";
			description = "Time to wake up the system (24h format HH:MM).";
		};
	};
}