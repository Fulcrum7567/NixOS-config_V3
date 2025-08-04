{ config, lib, pkgs-default, pkgs, ... }:
{


	config = lib.mkIf (config.theming.activeTheme == "nord") {
		theming = {
			polarity = "dark";

			fonts = {
				monospace.config = "jetBrainsMono";
				sansSerif.config = "dejaVuSans";
				serif.config = "dejaVuSerif";				
			};
		};
	};
}