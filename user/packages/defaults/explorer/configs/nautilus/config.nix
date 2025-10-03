{ config, lib, ... }:
{
	config = lib.mkIf (config.packages.defaults.explorer.active == "nautilus") {
		packages = {
			defaults.explorer = {
				appID = "org.gnome.Nautilus.desktop";
				launchCommand = "nautilus";
			};
			nautilus.enable = true;
		};
	};
}