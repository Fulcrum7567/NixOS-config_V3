{ config, lib, inputs, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.theming.components.${settings.optionName};
in
{
	
	imports = [
			inputs.mikuboot.nixosModules.default
	];

	config = lib.mkIf (option.enable && (option.active == "nordzy")) {
		stylix = {
			cursor = {
				package = pkgs-default.nordzy-cursor-theme;
				name = "Nordzy-cursors";
				size = 28;
			};
		};
		
		
	};
} 
