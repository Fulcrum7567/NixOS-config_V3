{ config, lib, settings, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/desktop/interface" = {
					enable-animations = true;
					enable-hot-corners = false;
					show-battery-percentage = true;
					toolkit-accessibility = false;
				};
			    
			};
		};
	};
} 
