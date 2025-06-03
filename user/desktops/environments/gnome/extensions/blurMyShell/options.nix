{ config, lib, ... }:
let
	extensionOption = config.desktopEnvironments.gnome.extensions.blurMyShell;
in
{
	options.desktopEnvironments.gnome.extensions.blurMyShell = {

		availableConfigs = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available configs for the blur-my-shell gnome extension.";
		};

		activeConfig = lib.mkOption {
			type = lib.types.enum (extensionOption.availableConfigs or []);
			default = "default"; # A default config should always exist, delete if not
			description = "Set the active configuration for the blur-my-shell gnome extension.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the blur-my-shell gnome extension.";
		};
	};
}