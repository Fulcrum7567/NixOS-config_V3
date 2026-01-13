{ config, lib, settings, ... }:
{
	options.packages.${settings.optionName} = {

		availableConfigs = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available configs for the ${settings.displayName} package.";
		};

		activeConfig = lib.mkOption {
			type = lib.types.enum (config.packages.${settings.optionName}.availableConfigs or []);
			default = "default"; # A default config should always exist, delete if not
			description = "Set the active configuration for the ${settings.displayName} package.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the ${settings.displayName} package.";
		};

		lockTimeout = lib.mkOption {
			type = lib.types.nullOr lib.types.int;
			default = 10*60; 
			description = "Time in seconds before the screen is locked. Set to null to disable.";
		};

		dimScreenTimeout = lib.mkOption {
			type = lib.types.nullOr lib.types.int;
			default = 1*60; 
			description = "Time in seconds before the screen is dimmed. Set to null to disable.";
		};

		sleepTimeout = lib.mkOption {
			type = lib.types.nullOr lib.types.int;
			default = 12*60; 
			description = "Time in seconds before the screen goes to sleep. Set to null to disable.";
		};

		suspendTimeout = lib.mkOption {
			type = lib.types.nullOr lib.types.int;
			default = 15*60; 
			description = "Time in seconds before the system suspends. Set to null to disable.";
		};



	};
}