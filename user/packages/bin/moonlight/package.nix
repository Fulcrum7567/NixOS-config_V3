{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		environment.systemPackages = [
			(pkgs-default.${settings.packageName})
		];
	};
}