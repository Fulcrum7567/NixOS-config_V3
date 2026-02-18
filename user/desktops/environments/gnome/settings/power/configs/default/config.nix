{ config, lib, settings, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/settings-daemon/plugins/power" = {
					idle-brightness = 30;
					idle-dim = true;
					power-button-action = "suspend";
					power-saver-profile-on-low-battery = true;
					sleep-inactive-ac-timeout = 900;
					sleep-inactive-ac-type = "suspend";
					sleep-inactive-battery-timeout = 300;
					sleep-inactive-battery-type = "suspend";
				};
			    
			};
		};
	};
} 
