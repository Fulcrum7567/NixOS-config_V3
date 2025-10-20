{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.activeTheme != null) {
		gtk = {
			iconTheme = {
				name = config.theming.icons.name;
				package = config.theming.icons.package;
			};
		};
	};
} 
