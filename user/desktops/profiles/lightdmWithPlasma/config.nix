{ config, lib, ... }:
{
	config = lib.mkIf (config.desktops.activeDesktop == "lightdmWithPlasma") {
		displayManagers.activeManager = "lightdm";
		desktopEnvironments.plasma.plasmaBase.enable = true;
	};
}