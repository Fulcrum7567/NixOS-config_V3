{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			home.file = {
			    ".config/Signal/ephemeral.json".text = builtins.toJSON {
			      	localeOverride = null;
			      	system-tray-setting = "MinimizeToAndStartInSystemTray";
			      	theme-setting = "system";
			      	spell-check = true;
			      	window = {
			        	maximized = true;
			        	autoHideMenuBar = false;
			        	fullscreen = false;
			        	width = 1920;
			        	height = 1126;
			        	x = 0;
			        	y = 35;
			      	};
			      	shown-tray-notice = true;
			    };
			};
		};
	};
} 
