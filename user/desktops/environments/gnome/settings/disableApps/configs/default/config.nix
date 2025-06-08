{ config, lib, settings, inputs, pkgs-default, pkgs, pkgs-stable, pkgs-unstable, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		environment.gnome.excludePackages = (with pkgs; [
			atomix # puzzle game
			epiphany # web browser
			evince # document viewer
			geary # email reader
			gedit # text editor
			gnome-music
			gnome-terminal
			gnome-tour
			hitori # sudoku game
			iagno # go game
			tali # poker game
			totem # video player
		]);
	};
} 
