{ config, lib, ... }:
{
	config = lib.mkIf (config.theming.gnome.cursor.override) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {
				"org/gnome/desktop/interface" = {
			    	cursor-theme = config.theming.gnome.cursor.cursor-theme;
			    };
		    };
		};
	};
} 
