{ config, lib, ... }:
{
	config = lib.mkIf (config.desktops.activeDesktop == "sddmWithGnomeAndPlasma") {
		displayManagers.activeManager = "sddm";
		desktopEnvironments.plasma.plasmaBase.enable = true;
		desktopEnvironments.gnome.simpleGnome.enable = true;
	};
}