{ config, lib, settings, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.${settings.optionName};
in
{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/shell/extensions/alphabetical-app-grid" = {

			      	folder-order-position = "start";
			      	sort-folder-contents = true;
			      	
			    };
			    
			};
		};
	};
} 
