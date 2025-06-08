{ config, lib, settings, inputs, pkgs-default, pkgs, pkgs-stable, pkgs-unstable, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "all")) {
		environment.gnome.excludePackages = (with pkgs; [
			atomix 			# puzzle game
			cheese 			# webcam tool
			epiphany 		# web browser
			evince 			# document viewer
			geary 			# email reader
			gedit 			# text editor
			gnome-characters
			gnome-music
			gnome-photos
			gnome-terminal
			gnome-tour
			hitori 			# sudoku game
			iagno 			# go game
			tali 			# poker game
			totem 			# video player
			yelp			# help
			gnome-maps		# maps
			simple-scan		# scan
			gnome-logs		# logs
		]);

		services.xserver.desktopManager.xterm.enable = false;
		services.xserver.excludePackages = [ pkgs-default.xterm ];

		documentation.nixos.enable = false;
	};
} 
