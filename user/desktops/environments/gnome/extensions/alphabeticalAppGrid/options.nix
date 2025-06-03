{ config, lib, ... }:
{
	options.desktopEnvironments.gnome.extensions.clipboardIndicator = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable the clipboard-indicator gnome extension.";
		};
	};
}