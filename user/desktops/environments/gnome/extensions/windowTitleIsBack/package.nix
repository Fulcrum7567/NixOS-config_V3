{ config, lib, pkgs, settings, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.extensions.${settings.optionName}.enable {

		# Package installation
		environment.systemPackages = [
			(pkgs.gnomeExtensions.${settings.officialName})
		];

		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				# Enable extension

				"org/gnome/shell" = {
					disable-user-extensions = false;
					enabled-extensions = [
						"${settings.officialID}"
					];
				};
			};
		};
	};
}