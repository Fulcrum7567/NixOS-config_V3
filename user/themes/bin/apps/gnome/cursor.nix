{ config, lib, ... }:
{
	config = {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = lib.mkIf (config.theming.useStylix == false) {
				"org/gnome/desktop/interface" = {
			    	cursor-theme = config.theming.cursors.name;
			    };
		    };
		};
	};
} 
