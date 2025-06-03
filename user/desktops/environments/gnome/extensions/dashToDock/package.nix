{ config, lib, pkgs, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.extensions.dashToDock.enable {

		# Package installation
		environment.systemPackages = with pkgs.gnomeExtensions; [
			dash-to-dock
		];

		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				# Enable extension

				"org/gnome/shell" = {
					disable-user-extensions = false;
					enabled-extensions = [
						"dash-to-dock@micxgx.gmail.com"
					];
				};
			};
		};
	};
}