{ config, lib, ... }:
{


	config = lib.mkIf (config.theming.activeTheme == "demoTheme") {
		theming = {
			plymouth.mikuboot.enable = true;

		};
	};
}