{ config, lib, settings, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/shell" = {
					favorite-apps = [ "${config.defaults.browser.appID}" ];
					welcome-dialog-last-shown-version = "99.2";
					remember-mount-password = true;
			    };
			    
			};
		};
	};
} 
