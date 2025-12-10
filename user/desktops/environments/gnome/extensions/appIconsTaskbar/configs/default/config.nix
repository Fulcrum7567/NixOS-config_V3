{ config, lib, settings, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.${settings.optionName};
in
{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/shell/extensions/aztaskbar" = {
			    favourites = false;
					intellihide = false;
					middle-click-action = "QUIT";
					position-in-panel = "LEFT";	
			  };  
			};
		};
	};
} 
