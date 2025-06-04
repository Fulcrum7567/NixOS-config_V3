{ config, lib, settings, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/desktop/peripherals/touchpad" = {
					send-events = true;
					disable-while-typing = true;
					tap-to-click = true;
					edge-scrolling-enabled = false;
					two-finger-scrolling-enabled = true;
					natural-scroll = true;
				};
			    
			};
		};
	};
} 
