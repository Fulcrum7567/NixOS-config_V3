{ config, lib, settings, ... }:
{
	options.hosts.fixes.${settings.optionName} = {

		availableConfigs = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available configs for the ${settings.displayName} fix.";
		};

		activeConfig = lib.mkOption {
			type = lib.types.enum (config.hosts.fixes.${settings.optionName}.availableConfigs or []);
			default = "default"; # A default config should always exist, delete if not
			description = "Set the active configuration for the ${settings.displayName} fix.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the ${settings.displayName} fix. Fixes the touchpad not getting initialized correctly on ASUS ROG Flow Z13.";
		};
	};
}