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


				# Configure extension
				"org/gnome/shell/extensions/clipboard-indicator" = {
					disable-down-arrow = true;
					history-size = 30;
					keep-selected-on-clear = true;
					display-mode = 0;
					paste-button = false;
					move-item-first = true;
					preview-size = 32;
					strip-text = true;
					toggle-menu = [ "<Super>v" ];
			    };

				# End of extension configuration
			};
		};
	};
}