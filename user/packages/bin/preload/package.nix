{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, inputs, ... }:
{
	imports = [
		inputs.preload-ng.nixosModules.default
	];

	config = lib.mkIf config.packages.${settings.optionName}.enable {

		# Package installation
		services.preload-ng.enable = true;
	};
}