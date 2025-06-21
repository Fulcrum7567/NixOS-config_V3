{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "6_14")) {

		boot.kernelPackages = pkgs.linuxPackages_6_14;
		
	};
} 
