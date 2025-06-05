{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		home-manager.users.${config.user.settings.username} = {
			home.sessionVariables = {
				STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
			};
		};

		programs = {
		
			steam = {
				remotePlay.openFirewall = true;
				gamescopeSession.enable = true;
				extraCompatPackages = [ pkgs-default.proton-ge-bin ];
			};

			gamemode.enable = true;
		};

		environment.variables = {
	  		"STEAM_FORCE_WAYLAND" = "1";
			SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = 0;

		};


	};
} 
