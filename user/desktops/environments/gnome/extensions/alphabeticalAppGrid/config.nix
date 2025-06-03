{ config, lib, pkgs, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.extensions.alphabeticalAppGrid.enable {

		# Package installation
		environment.systemPackages = with pkgs.gnomeExtensions; [
			alphabetical-app-grid
		];

		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				# Enable extension

				"org/gnome/shell" = {
					disable-user-extensions = false;
					enabled-extensions = [
						"AlphabeticalAppGrid@stuarthayhurst"
					];
				};


				# Configure extension
				"org/gnome/shell/extensions/alphabetical-app-grid" = {
					folder-order-position = "start";
					sort-folder-contents = true;
			    };

				# End of extension configuration
			};
		};
	};
}