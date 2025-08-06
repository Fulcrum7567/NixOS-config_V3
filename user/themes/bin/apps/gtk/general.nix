{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = {
		gtk = {
			enable = true;

			theme.name = config.theming.baseGTKTheme;
		};
	};
} 
