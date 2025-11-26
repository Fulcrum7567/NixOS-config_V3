{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.gtk.polarity.override) {
		gtk = {
			gtk3.extraConfig = {
				Settings = ''
					gtk-application-prefer-dark-theme=${config.theming.gtk.polarity.value};
				'';
			};

			gtk4.extraConfig = {
				Settings = ''
					gtk-application-prefer-dark-theme=${config.theming.gtk.polarity.value};
				'';
			};
		};
	};
}