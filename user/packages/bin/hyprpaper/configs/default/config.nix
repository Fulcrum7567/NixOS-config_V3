{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			services.hyprpaper.settings = {
				ipc = "on";
				splash = false;
				splash_offset = 2.0;
			};
		};
	};
} 
