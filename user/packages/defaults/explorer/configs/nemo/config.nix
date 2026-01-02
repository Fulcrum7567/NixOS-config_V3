{ config, lib, ... }:
{
	config = lib.mkIf (config.packages.defaults.explorer.active == "nemo") {
		packages = {
			defaults.explorer = {
				appID = "nemo.desktop";
				launchCommand = "nemo";
			};
			nemo.enable = true;
		};
	};
}