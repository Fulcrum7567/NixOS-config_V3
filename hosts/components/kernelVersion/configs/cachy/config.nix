{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "cachy")) {

		boot.kernelPackages = (if (config.host.settings.systemType == "server") then pkgs.linuxPackages_cachyos-server else pkgs.linuxPackages_cachyos);
		
	};
} 
