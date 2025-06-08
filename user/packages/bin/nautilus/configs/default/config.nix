{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/nautilus/preferences" = {
					default-folder-viewer = "list-view";
				};
			    
			};
		};

		programs.nautilus-open-any-terminal = {
			enable = true;
			terminal = config.packages.defaults.terminal.active;
		};
	};
} 
