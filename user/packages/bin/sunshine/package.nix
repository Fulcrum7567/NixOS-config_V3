{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		services.sunshine = {
			enable = true;
			autoStart = true;
			capSysAdmin = true;
			openFirewall = true;
		};
	};
}