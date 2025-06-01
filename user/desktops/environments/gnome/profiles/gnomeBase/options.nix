{ config, lib, ... }:
{
	options.desktopEnvironments.gnome.gnomeBase = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable 'gnome base' desktop environment";
		};
	};
}