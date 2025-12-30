{ config, lib, pkgs-default, pkgs, inputs, ... }:
{


	config = lib.mkIf (config.theming.activeTheme == "nord") {

		system.inputUpdates = [ "nix-colors" ];

		colorScheme = inputs.nix-colors.colorSchemes.nord;

		theming = {

			gnome = {
				accentColor = "slate";
			};

			
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
					delay = 300;
				};

				
				single.active = "cpu_city.png";
			};

			cursors = {
				active = "nordzy";
				size = 28;
			};

			plymouth = {
				enable = true;
				activeTheme = "default";
			};

			icons.active = "nordzy";

			apps = {
				wlogout.activeConfig = "sheng";
				waybar = {
					window = {
						enable = true;
						activeConfig = "slyHarvey";
					};

					tooltips = {
						enable = true;
						activeConfig = "custom1";
					};

					general = {
						enable = true;
						activeConfig = "custom1";
					};

					colors = {
						enable = true;
						activeConfig = "dynamic";
					};

					modules = {
						enable = true;
						activeConfig = "custom1";

						clock = {
							enable = true;
							activeConfig = "custom1";
						};

						hyprland = {
							workspaces = {
								enable = true;
								activeConfig = "custom1";
							};
							window = {
								enable = true;
								activeConfig = "custom1";
							};
						};

						custom = {
							wlogout = {
								enable = true;
								activeConfig = "custom1";
							};
						};
					};

					
				};
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