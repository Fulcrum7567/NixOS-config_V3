{ config, lib, pkgs-default, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		# Package installation
		environment.systemPackages = [
			(pkgs-default.${settings.packageName})
		];
	};
}