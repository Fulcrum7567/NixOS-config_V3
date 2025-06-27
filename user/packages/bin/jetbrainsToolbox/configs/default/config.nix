{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			xdg.desktopEntries = {
				jetbrains-toolbox = {
					name = "Jetbrains Toolbox";
					genericName = "Jetbrains Toolbox";
					exec = "jetbrains-toolbox";
					icon = ./toolbox.png;
					categories = [ ];
					noDisplay = false;
				};
			};
		};
	};
} 
