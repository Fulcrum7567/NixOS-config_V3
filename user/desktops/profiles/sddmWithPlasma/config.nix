{ config, lib, ... }:
{
	config = lib.mkIf (config.desktops.activeDesktop == "sddmWithPlasma") {
		displayManagers.activeManager = "sddm";
		desktopEnvironments.plasma.plasmaBase.enable = true;
	};
}