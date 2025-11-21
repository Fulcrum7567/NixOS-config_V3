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

		users.users.${config.user.settings.username}.extraGroups = [ "steam" ];

		programs = {
		
			steam = {
				extest.enable = true;
				remotePlay.openFirewall = true;
				gamescopeSession = {
					enable = true;
					env = {
						WLR_RENDERER = "vulkan";
						DXVK_HDR = "1";
						ENABLE_GAMESCOPE_WSI = "1";
						ENABLE_HDR_WSI = "1";
						WINE_FULLSCREEN_FSR = "1";
					};
					args = [
						 "-e" # Enable steam integration
						"--adaptive-sync"
						"--hdr-enabled"
						"--hdr-itm-enable"
					];

				};
				extraCompatPackages = [ pkgs-default.proton-ge-bin ];
				extraPackages = with pkgs-default; [
					xorg.libXcursor
					xorg.libXi
					xorg.libXinerama
					xorg.libXScrnSaver
					libpng
					libpulseaudio
					libvorbis
					stdenv.cc.cc.lib
					libkrb5
					keyutils
				];
			};

			gamemode.enable = true;
		};

		environment.variables = {
	  		"STEAM_FORCE_WAYLAND" = "1";
			SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = 0;

		};


	};
} 
