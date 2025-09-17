{ config, lib, pkgs-default, pkgs, inputs, ... }:
{


	config = lib.mkIf (config.theming.activeTheme == "nord") {

		colorScheme = inputs.nix-colors.colorSchemes.nord;

		theming = {
			polarity = "dark";

			fonts = {
				monospace.config = "jetBrainsMono";
				sansSerif.config = "dejaVuSans";
				serif.config = "dejaVuSerif";				
			};

			wallpaper = {
				type = "single";
				active = ../../bin/wallpapers/bin/cpu_city.png;
			};

			cursors = {
				active = "nordzy";
				size = 28;
			};

			icons.active = "nordzy";

			useStylix = true;

		};
	};
}