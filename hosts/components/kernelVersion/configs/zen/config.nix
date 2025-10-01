{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "zen")) {

		boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
		
	};
} 
