{ config, lib, pkgs, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.extensions.middleClickToClose.enable {

		# Package installation
		environment.systemPackages = with pkgs.gnomeExtensions; [
			middle-click-to-close-in-overview
		];

		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				# Enable extension

				"org/gnome/shell" = {
					disable-user-extensions = false;
					enabled-extensions = [
						"middleclickclose@paolo.tranquilli.gmail.com"
					];
				};
			};
		};
	};
}