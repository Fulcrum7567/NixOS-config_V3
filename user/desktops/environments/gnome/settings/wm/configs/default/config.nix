{ config, lib, settings, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/desktop/wm/preferences" = {
			    	focus-new-windows = "smart";
			    	button-layout = "appmenu:minimize,maximize,spacer,close";
			    	resize-with-right-button = true;
			    };
	    
			};
		};
	};
} 
