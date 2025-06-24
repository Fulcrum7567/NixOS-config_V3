{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		# Graphical package
		services.mullvad-vpn.package = pkgs-default.mullvad-vpn;
	};
} 
