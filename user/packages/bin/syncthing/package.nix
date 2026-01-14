{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {
		
		services.syncthing = {
			enable = true;
			user = "syncthing";
			group = "syncthing";

			settings = {
				gui = {
					user = config.user.settings.username;
        			theme = (if (config.theming.polarity == "light") then "light" else "dark");
					password = "$2a$10$HWGHFG2AZN3m3bb3OUfyHOoTky57TeC8flop.HfkJqF5UMyD1ha82";
				};
			};
		};

	};
}