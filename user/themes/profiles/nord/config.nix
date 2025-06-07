{ config, lib, pkgs-default, ... }:
{


	config = lib.mkIf (config.theming.activeTheme == "nord") {
		theming.components = {
			plymouth.enable = true;
		};

		stylix = {
			enable = true;
			autoEnable = true;

			base16Scheme = "${pkgs-default.base16-schemes}/share/themes/nord.yaml";
			
		};

	};
}