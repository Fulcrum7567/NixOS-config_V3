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
				disableDesktopIcons.enable = true;

				mouse = {
					enable = true;
					active = "nordzy";
				};

				wallpaper = {
					enable = true;
					type = "single";
					active = "cpu_city.png";
				};
			};
		};

		stylix = {
			enable = true;
			autoEnable = true;

			polarity = "dark";

			targets.qt.enable = false;
		};

		
		

	
	};
}