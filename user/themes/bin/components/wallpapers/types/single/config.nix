{ config, lib, inputs, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.theming.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.type == "single")) {

		stylix.image = ../../bin/${option.active};
		
	};
} 
