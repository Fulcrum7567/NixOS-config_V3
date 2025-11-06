{ config, lib, ... }:
{
	config = lib.mkIf (config.desktops.activeDesktop == "gdmWithGnome") {
		displayManagers.activeManager = "gdm";
		desktopEnvironments.gnome.simpleGnome.enable = true;
	};
}