{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.activeTheme != null) {
		gtk = {
			cursorTheme = {
				name = config.theming.cursors.name;
				package = config.theming.cursors.package;
				size = config.theming.cursors.size;
			};
		};
	};
} 
