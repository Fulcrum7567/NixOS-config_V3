{ config, lib, inputs, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.theming.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.active == "default")) {

		stylix = {
			fonts = {
				monospace = {
					package = pkgs-default.nerd-fonts.jetbrains-mono;
					name = "JetBrainsMono Nerd Font Mono";
				};

				sansSerif = {
					package = pkgs-default.dejavu_fonts;
					name = "DejaVu Sans";
				};

				serif = {
					package = pkgs-default.dejavu_fonts;
					name = "DejaVu Serif";
				};

				sizes = {
					applications = 12;
					terminal = 15;
					desktop = 10;
					popups = 10;
				};
			};
		};
		
	};
} 
