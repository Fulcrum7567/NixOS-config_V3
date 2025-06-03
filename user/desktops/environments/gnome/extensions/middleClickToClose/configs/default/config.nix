{ config, lib, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.middleClickToClose;
in
{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {
				
				"org/gnome/shell/extensions/middleclickclose" = {
					close-button = "middle";
					keyboard-close = true;
					rearrange-delay = 100;
			    };
			    
			};
		};
	};
} 
