{ config, lib, settings, ... }:
{
	options.theming.components.${settings.optionName} = {

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available configs for the ${settings.displayName} component.";
		};

		active = lib.mkOption {
			type = lib.types.enum (config.theming.components.${settings.optionName}.available or []);
			default = "default"; # A default config should always exist, delete if not
			description = "Set the active configuration for the ${settings.displayName} component.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable ${settings.displayName} components.";
		};
	};
}