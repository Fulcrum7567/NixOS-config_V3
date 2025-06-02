{ config, lib, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.gnomeBase.enable {
		services.desktopManager.gnome.enable = true;
	};
}