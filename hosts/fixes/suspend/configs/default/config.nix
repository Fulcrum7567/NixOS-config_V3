{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.fixes.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		boot.kernelParams = [
		    "mmc_core.disable_uhs2=1"
		    "mem_sleep_default=deep"
		];  
	};
} 
