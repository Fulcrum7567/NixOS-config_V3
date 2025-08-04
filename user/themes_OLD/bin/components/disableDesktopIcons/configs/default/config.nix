{ config, lib, inputs, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.theming.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.active == "default")) {
		home-manager.users.${config.user.settings.username} = {
			xdg.desktopEntries = {
				kvantummanager = {
					name = "Kvantum Manager";
					genericName = "Kvantum Theme Manager";
					exec = "kvantummanager";
					icon = "kvantummanager";
					categories = [ "Settings" "Qt" ];
					noDisplay = true;
				};

				qt5ct = {
					name = "Qt5 Settings"; 
					genericName = "Qt5 Configuration Tool";
					exec = "qt5ct"; 
					icon = "qt5ct"; 
					categories = [ "Settings" "Qt" ];
					noDisplay = true; 
				};

				qt6ct = {
					name = "Qt6 Settings";
					genericName = "Qt6 Configuration Tool";
					exec = "qt6ct"; 
					icon = "qt6ct"; 
					categories = [ "Settings" "Qt" ];
					noDisplay = true; 
				};
			};
		};
	};
} 
