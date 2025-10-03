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
				diashow = {
					active = {
						name = "nord";
						wallpapers = [ "cpu_city.png" "forest1.jpg" "girlOnBed.png" "japan1.png" "mountainRange1.png" "mountainRange2.jpg" "nixos.png" "seashore1.png" "yourName.png" ];
					};
					delay = 180;
				};

				
				single.active = "cpu_city.png";
			};

			cursors = {
				active = "nordzy";
				size = 28;
			};

			plymouth = {
				enable = true;
				activeTheme = "mikuboot";
			};

			icons.active = "nordzy";

			apps = {
				hyprland.bin = {
					animations.enable = true;
					decorations.enable = true;
					general.enable = true;
					misc.enable = true;
				};
			};

		};
	};
}