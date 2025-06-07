{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.theming.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.active == "default")) {

		boot.plymouth.enable = true;
		
	};
} 
