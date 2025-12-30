{ config, lib, ... }:
{
	config = lib.mkIf (config.packages.defaults.lockscreen.active == "hyprlock") {
		packages = {
			defaults = {
				lockscreen.launchCommand = "hyprlock";
			};
			
			hyprlock.enable = true;
		};
	};
}