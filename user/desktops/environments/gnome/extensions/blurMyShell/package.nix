{ config, lib, pkgs, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.extensions.blurMyShell.enable {
		environment.systemPackages = with pkgs.gnomeExtensions; [
			blur-my-shell
		];
		home-manager.users.${config.user.settings.username} =  {
			dconf.settings = {

				# Enable extension

				"org/gnome/shell" = {
					disable-user-extensions = false;
					enabled-extensions = [
						pkgs.gnomeExtensions.blur-my-shell.extensionUuid
					];
				};
			};
		};
	};
}