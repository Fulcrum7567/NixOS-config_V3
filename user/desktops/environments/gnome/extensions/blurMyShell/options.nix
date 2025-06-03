{ config, lib, ... }:
{
	options.desktopEnvironments.gnome.extensions.blurMyShell = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the blur-my-shell gnome extension.";
		};
	};
}