{ config, lib, inputs, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.theming.components.${settings.optionName};
in
{
	
	imports = [
			inputs.mikuboot.nixosModules.default
	];

	config = lib.mkIf (option.enable && (option.active == "mikuboot")) {

		boot.plymouth = {
			enable = true;

			themePackages = lib.mkForce [ pkgs.mikuboot ];
			theme = lib.mkForce "mikuboot";
		};
		
	};
} 
