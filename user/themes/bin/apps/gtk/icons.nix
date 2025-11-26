{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.gtk.icons.override) {
		gtk = {
			iconTheme = {
				name = config.theming.gtk.icons.value.name;
				package = config.theming.gtk.icons.value.package;
			};
		};
	};
} 
