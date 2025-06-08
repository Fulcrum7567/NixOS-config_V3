{ config, lib, pkgs-default, ... }:
{


	config = lib.mkIf (config.theming.activeTheme == "nord") {

		

		theming = {
			colorScheme = "nord";
			polarity = "dark";

			components = {
				plymouth.enable = true;
			};
		};

		stylix = {
			enable = true;
			autoEnable = false;
			
		};

	};
}