{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, waybar, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		# Package installation
		home-manager.users.${config.user.settings.username} = {
			programs.waybar = {
				enable = true;
				package = waybar.packages.${pkgs-default.stdenv.hostPlatform.system}.waybar;
			};
		};
	};
}