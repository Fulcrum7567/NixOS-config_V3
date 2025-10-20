{ config, lib, ... }:
{
	config = {
		home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.activeTheme != null) {
			dconf.settings = lib.mkIf (config.theming.useStylix == false) {
				"org/gnome/desktop/interface" = {
			    	cursor-theme = config.theming.cursors.name;
			    };
		    };
		};
	};
} 
