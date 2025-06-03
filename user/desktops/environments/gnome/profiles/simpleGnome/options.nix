{ config, lib, ... }:
{
	options.desktopEnvironments.gnome.simpleGnome = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable 'simple gnome' desktop environment";
		};
	};
}