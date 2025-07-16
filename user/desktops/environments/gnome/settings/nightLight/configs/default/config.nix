{ config, lib, settings, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/settings-deamon/plugins/color" = {
					night-light-enabled = settingsConfig.on;
					night-light-temperature = 2000;
					night-light-schedule-automatic = false;
				};
			    
			};
		};
	};
} 
