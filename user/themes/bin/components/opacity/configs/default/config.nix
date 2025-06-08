{ config, lib, inputs, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.theming.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.active == "default")) {

		stylix = {
			opacity = {
				applications = 1.0;
				terminal = 0.8;
				desktop = 1.0;
				popups = 0.8;
			};
		};
	};
} 
