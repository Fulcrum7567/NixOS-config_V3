{ config, lib, ... }:
let
	extensionOption = config.desktopEnvironments.gnome.extensions.alphabeticalAppGrid;
in
{
	options.desktopEnvironments.gnome.extensions.alphabeticalAppGrid = {

		availableConfigs = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available configs for the alphabetical-app-grid gnome extension.";
		};

		activeConfig = lib.mkOption {
			type = lib.types.enum (extensionOption.availableConfigs or []);
			default = "default"; # A default config should always exist, delete if not
			description = "Set the active configuration for the alphabetical-app-grid gnome extension.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the alphabetical-app-grid gnome extension.";
		};
	};
}