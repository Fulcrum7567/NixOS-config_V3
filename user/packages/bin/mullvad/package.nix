{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		# Package installation
		services.mullvad-vpn.enable = true;

		# Needed for now
		services.resolved.enable = true;
	};
}