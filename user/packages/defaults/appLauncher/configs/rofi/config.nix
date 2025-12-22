{ config, lib, ... }:
let 
	ts = if (config.packages.defaults.appLauncher.rofi.themeStr != null) then "-theme-str \"${config.packages.defaults.appLauncher.rofi.themeStr}\"" else "";
	tf = if (config.packages.defaults.appLauncher.rofi.themeFile != null) then "-theme \"${config.packages.defaults.appLauncher.rofi.themeFile}\"" else "";
in 
{
	config = lib.mkIf (config.packages.defaults.appLauncher.active == "rofi") {
		packages = {
			defaults = {
				appLauncher.appID = "";
				appLauncher.launchCommand = "rofi -show drun ${ts} ${tf}";
			};
			
			rofi.enable = true;
		};
	};
}