{ config, lib, pkgs, ... }:
{
	config = lib.mkIf config.theming.useStylix {

		system.inputUpdates = [ "stylix-stable" "stylix-unstable" ];

		stylix = {
			enable = config.theming.useStylix;
			base16Scheme = config.colorScheme.palette;
			autoEnable = true;

			targets = {
				plymouth.enable = config.theming.plymouth.enable && (config.theming.plymouth.activeTheme == "default");
			};

			icons = {
				enable = config.theming.useStylix;
				dark = config.theming.icons.name;
				light = config.theming.icons.name;
				package = config.theming.icons.package;
			};


			polarity = (if (config.theming.polarity == "mixed") then "either" else config.theming.polarity);
		
		};

		home-manager.users.${config.user.settings.username} = {
			
			stylix.targets = {
				waybar.enable = false;
			};

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
