{ config, lib, settings, ... }:
let
	extensionOption = config.desktopEnvironments.gnome.extensions.${settings.optionName};
in
{
	options.desktopEnvironments.gnome.extensions.${settings.optionName} = {

		availableConfigs = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available configs for the ${settings.officialName} gnome extension.";
		};

		activeConfig = lib.mkOption {
			type = lib.types.enum (extensionOption.availableConfigs or []);
			default = "default"; # A default config should always exist, delete if not
			description = "Set the active configuration for the ${settings.officialName} gnome extension.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the ${settings.officialName} gnome extension.";
		};
	};
}