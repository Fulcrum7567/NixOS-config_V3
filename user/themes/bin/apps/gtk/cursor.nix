{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.gtk.cursor.override) {
		gtk = {
			cursorTheme = {
				name = config.theming.gtk.cursor.value.name;
				package = config.theming.gtk.cursor.value.package;
				size = config.theming.gtk.cursor.value.size;
			};
		};
	};
} 
