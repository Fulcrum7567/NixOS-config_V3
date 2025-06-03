{ config, lib, ... }:
{
	options.desktopEnvironments.gnome.extensions.alphabeticalAppGrid = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the alphabetical-app-grid gnome extension.";
		};
	};
}