{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, nvf, ... }:
{

	imports = [
		nvf.nixosModules.default
	];

	config = lib.mkIf config.packages.${settings.optionName}.enable {

		system.inputUpdates = [ "nvf-unstable" "nvf-stable" ];

		programs.nvf = {
			enable = true;
		};
		
	};
}