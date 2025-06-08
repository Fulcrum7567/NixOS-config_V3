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
			default = "cuteIcon"; # A default config should always exist, delete if not
			description = "Set the active configuration for the ${settings.displayName} package.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the ${settings.displayName} package.";
		};
	};
}