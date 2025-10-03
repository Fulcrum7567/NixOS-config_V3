{ config, lib, ... }:
{
	config = lib.mkIf (config.packages.defaults.appLauncher.active == "rofi") {
		packages = {
			defaults = {
				appLauncher.appID = "";
				appLauncher.launchCommand = "rofi -show drun -show-icons";
			};
			
			rofi.enable = true;
		};
	};
}