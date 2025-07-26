{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, nvf, ... }:
{

	imports = [
		nvf.nixosModules.default
	];

	config = lib.mkIf config.packages.${settings.optionName}.enable {

		programs.nvf = {
			enable = true;
		};
		
	};
}