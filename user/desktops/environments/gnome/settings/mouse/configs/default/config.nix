{ config, lib, settings, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/desktop/peripherals/mouse" = {
					accel-profile = "flat";
					double-click = 400;
					drag-threshold = 8;
					left-handed = false;
					middle-click-emulation = false;
					speed = 0.35;
				};
			    
			};
		};
	};
} 
