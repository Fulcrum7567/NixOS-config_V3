{ config, lib, ... }:
{
	config = {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {
				"org/gnome/desktop/interface" = {
			    	cursor-theme = config.theming.cursors.name;
			    };
		    };
		};
	};
} 
