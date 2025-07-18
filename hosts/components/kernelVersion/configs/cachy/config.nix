{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, inputs, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	
	imports = [
		inputs.cachyos-kernel.nixosModules.default
	];

	config = lib.mkIf (option.enable && (option.activeConfig == "cachy")) {

		nix.settings = {
			substituters = [ "https://drakon64-nixos-cachyos-kernel.cachix.org" ];
			trusted-public-keys = [ "drakon64-nixos-cachyos-kernel.cachix.org-1:J3gjZ9N6S05pyLA/P0M5y7jXpSxO/i0rshrieQJi5D0=" ];
		};

		boot.kernelPackages = with pkgs; linuxPackagesFor linuxPackages_cachyos;
		
	};
} 
