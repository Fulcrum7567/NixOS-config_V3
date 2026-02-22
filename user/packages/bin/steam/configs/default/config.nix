{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		home-manager.users.${config.user.settings.username} = { lib, ... }: {
			home.sessionVariables = {
				STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
			};

			# Fix icon not showing in GNOME
			home.activation.fixSteamDesktopFiles = let
				desktopDir = "~/.local/share/applications";
			in lib.hm.dag.entryAfter ["writeBoundary"] ''
				# Check if the directory exists
				if [ -d ${desktopDir} ]; then
					echo "Fixing Steam game desktop files in ${desktopDir}..."
					# Find all .desktop files that were created by Steam (they contain 'steam://rungameid/')
					${pkgs-default.findutils}/bin/find ${desktopDir} -name "*.desktop" -type f -exec ${pkgs-default.gnugrep}/bin/grep -l 'steam://rungameid/' {} \; | while read file; do
						# Extract the Game ID from the Exec line
						GAMEID=$(${pkgs-default.gnused}/bin/sed -n 's/.*steam:\/\/rungameid\/\([0-9]*\).*/\1/p' "$file")
						if [ -n "$GAMEID" ]; then
							# Check if StartupWMClass line already exists
							if ! ${pkgs-default.gnugrep}/bin/grep -q "^StartupWMClass=" "$file"; then
								echo "Adding StartupWMClass=steam_app_$GAMEID to $(basename "$file")"
								# Add the line after the [Desktop Entry] section
								${pkgs-default.gnused}/bin/sed -i "/^\[Desktop Entry\]/a StartupWMClass=steam_app_$GAMEID" "$file"
							fi
						fi
					done
				fi
			'';
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
					libxcursor
					libxi
					libxinerama
					libxscrnsaver
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
