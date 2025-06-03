{ config, lib, ... }:
{
	config = lib.mkIf (config.desktops.activeDesktop == "gnomeWithGdm") {
		displayManagers.activeManager = "gdm";
		desktopEnvironments.gnome.simpleGnome.enable = true;
	};
}