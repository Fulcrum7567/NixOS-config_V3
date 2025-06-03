{ config, lib, ... }:
{
	options.desktopEnvironments.gnome.extensions.dashToDock = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the dash-to-dock gnome extension.";
		};
	};
}