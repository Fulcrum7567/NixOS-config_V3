{ config, lib, ... }:
{
	config.packages.defaults.appLauncher.available = [ "rofi" ];

	options.packages.defaults.appLauncher.rofi = {
		themeStr = lib.mkOption {
			type = lib.types.nullOr lib.types.str;
			default = "entry{placeholder:'Search Applications...';}listview{lines:9;}";
			description = "Rofi theme string for the application launcher.";
		};

		themeFile = lib.mkOption {
			type = lib.types.nullOr lib.types.str;
			default = null;
			description = "Path to a custom Rofi theme file. Starting from ~/.config/rofi/launchers/";
		};
	};
}