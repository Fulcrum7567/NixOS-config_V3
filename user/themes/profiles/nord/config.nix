{ config, lib, pkgs-default, pkgs, ... }:
{


	config = lib.mkIf (config.theming.activeTheme == "nord") {

		theming = {
			colorScheme = "nord";
			polarity = "dark";

			components = {
				plymouth.enable = true;
				opacity.enable = true;
				fonts.enable = true;

				mouse = {
					enable = true;
					active = "nordzy";
				};

				wallpaper = {
					enable = true;
					type = "single";
					active = "all/cpu_city.png";
				};
			};
		};

		stylix = {
			enable = true;
			autoEnable = true;

			targets.qt.enable = false;
		};

	
	};
}