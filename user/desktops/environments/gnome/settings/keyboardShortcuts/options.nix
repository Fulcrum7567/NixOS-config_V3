{ config, lib, settings, ... }:
let
	settingOption = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	options.desktopEnvironments.gnome.settings.${settings.optionName} = {

		availableConfigs = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available configs for ${settings.displayName}.";
		};

		activeConfig = lib.mkOption {
			type = lib.types.enum (settingOption.availableConfigs or []);
			default = "default"; # A default config should always exist, delete if not
			description = "Set the active configuration for ${settings.displayName}.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable ${settings.displayName}.";
		};
	};
} 
