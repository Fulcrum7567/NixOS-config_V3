{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			xdg.desktopEntries = {
				nvim = {
					name = "Neovim";
					genericName = "Neovim";
					exec = "${lib.replaceStrings [ "<command>" ] [ "nvim" ] config.packages.defaults.terminal.launchWithCommand}";
					icon = "nvim";
					categories = [  ];
					noDisplay = false;
				};
			};
		};
	};
} 
