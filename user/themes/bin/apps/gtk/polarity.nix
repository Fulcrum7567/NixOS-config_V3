{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.activeTheme != null) {
		gtk = {
			gtk3.extraConfig = {
				Settings = ''
					gtk-application-prefer-dark-theme=1
				'';
			};

			gtk4.extraConfig = {
				Settings = ''
					gtk-application-prefer-dark-theme=1
				'';
			};
		};
	};
}