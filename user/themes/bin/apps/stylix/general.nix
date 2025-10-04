{ config, lib, pkgs, ... }:
{
	config = lib.mkIf config.theming.useStylix {

		stylix = {
			enable = config.theming.useStylix;
			base16Scheme = config.colorScheme.palette;
			autoEnable = true;

			targets = {
				plymouth.enable = false;
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
