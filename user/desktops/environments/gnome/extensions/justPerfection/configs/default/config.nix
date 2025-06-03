{ config, lib, settings, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.${settings.optionName};
in
{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/shell/extensions/just-perfection" = {
					accent-color-icon = false;
					activities-button = true;
					animation = 4;
					clock-menu = true;
					keyboard-layout = false;
					max-displayed-search-results = 10;
					notification-banner-position = 2;
					panel = true;
					power-icon = true;
					quick-settings = true;
					quick-settings-dark-mode = false;
					quick-settings-night-light = false;
					search = true;
					show-apps-button = false;
					support-notifier-showed-version = 34;
					world-clock = false;
			    };
			    
			};
		};
	};
} 
