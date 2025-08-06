{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = {
		gtk = {
			iconTheme = {
				name = config.theming.icons.name;
				package = config.theming.icons.package;
			};
		};
	};
} 
