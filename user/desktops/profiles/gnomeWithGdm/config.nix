{ config, lib, ... }:
{
	config = lib.mkIf (config.desktops.activeDesktop == "gnomeWithGdm") {
		config.displayManagers.activeManager = "gdm";
	};
}