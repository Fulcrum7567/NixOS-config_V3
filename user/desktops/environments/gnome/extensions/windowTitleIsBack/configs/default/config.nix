{ config, lib, settings, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.${settings.optionName};
in
{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/shell/extensions/window-title-is-back" = {
			    	colored-icon = false;
					fixed-width = false;
					show-icon = false;
					show-title = false;
			    };
			    
			};
		};
	};
} 
