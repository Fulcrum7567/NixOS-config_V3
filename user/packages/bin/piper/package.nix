{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		# Package installation
		environment.systemPackages = [
			(pkgs-default.${settings.packageName})
		];

		services.ratbagd.enable = true;

		
	};
}