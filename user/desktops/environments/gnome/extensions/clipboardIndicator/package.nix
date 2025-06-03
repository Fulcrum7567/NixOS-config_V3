{ config, lib, pkgs, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.extensions.clipboardIndicator.enable {

		# Package installation
		environment.systemPackages = with pkgs.gnomeExtensions; [
			clipboard-indicator
		];

		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				# Enable extension

				"org/gnome/shell" = {
					disable-user-extensions = false;
					enabled-extensions = [
						"clipboard-indicator@tudmotu.com"
					];
				};
			};
		};
	};
}