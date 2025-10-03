{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		# Package installation
		home-manager.users.${config.user.settings.username} = {
			programs.waybar.enable = true;
		};
	};
}