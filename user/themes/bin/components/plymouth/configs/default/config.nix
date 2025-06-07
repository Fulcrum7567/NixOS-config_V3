{ config, lib, inputs, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.theming.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.active == "default")) {

		boot.plymouth.enable = true;
		stylix.targets.plymouth = {
			enable = true;
			logo = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png";
			logoAnimated = true;
		};
		
	};
} 
