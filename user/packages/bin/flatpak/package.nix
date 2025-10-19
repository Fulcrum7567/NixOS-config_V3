{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, inputs, ... }:
{

	imports = [
		inputs.flatpak.nixosModules.nix-flatpak
	];

	config = lib.mkIf config.packages.${settings.optionName}.enable {

		system.inputUpdates = [ "flatpak" ];
		
		services.flatpak.enable = true;
		
	};
}