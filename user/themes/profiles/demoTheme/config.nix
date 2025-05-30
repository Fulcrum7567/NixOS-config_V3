{ config, lib, ... }:
{
	config = lib.mkIf (config.theming.activeTheme == "demoTheme") {
		theming = {
			isThemeActive = true;
			plymouth.mikuboot.enable = true;

		};



	};
}