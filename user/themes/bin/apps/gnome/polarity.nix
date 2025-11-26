{ config, lib, ... }:
{
	config = lib.mkIf (config.theming.gnome.polarity.override) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {
				"org/gnome/desktop/interface" = {
					color-scheme = config.theming.gnome.polarity.value;
				};
			};
		};
	};
} 
