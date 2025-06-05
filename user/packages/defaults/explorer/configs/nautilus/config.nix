{ config, lib, ... }:
{
	config = lib.mkIf (config.defaults.explorer.active == "nautilus") {
		defaults.explorer.appID = "org.gnome.Nautilus.desktop";
		packages.nautilus.enable = true;
	};
}