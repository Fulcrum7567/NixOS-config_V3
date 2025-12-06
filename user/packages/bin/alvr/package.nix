{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {
		programs.alvr = {
			enable = true;
			openFirewall = true;
		};
	};
}