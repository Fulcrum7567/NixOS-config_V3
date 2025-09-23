{ config, lib, pkgs, ... }:
{
	config = {
		assertions = [
			{
				assertion = (config.theming.wallpaper.type != "diashow") || (config.theming.wallpaper.diashow.active != null);
				message = "Diashow Wallpaper is enabled but not set.";
			}
			{
				assertion = (config.theming.wallpaper.type != "diashow") || (config.theming.wallpaper.diashow.selectCommand != null);
				message = "Diashow Wallpaper is enabled but no command to select one is set.";
			}
		];

		systemd.user.services.wallpaper-diashow = {
			description = "Wallpaper Diashow Service";
			wantedBy = lib.mkIf (config.theming.wallpaper.type == "diashow") [ "default.target" ];
			after = [ "graphical-session.target" ];
			enable = config.theming.wallpaper.type == "diashow";
			
			path = with pkgs; [ 
				glib  # for gsettings
				bash
				coreutils
				findutils
				gnugrep
				gnused
			];
			
			environment = {
				DISPLAY = ":0";
				XDG_RUNTIME_DIR = "/run/user/1000";
			};
			
			serviceConfig = {
				Type = "simple";
				Restart = "always";
				RestartSec = 5;
				ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
			};

			script = let
				wallpaperScript = ''
					#!/bin/bash
					
					WALLPAPER_DIR="${config.theming.wallpaper.wallpaperPath}"
					WALLPAPERS=(${lib.concatStringsSep " " (map (w: "\"${w}\"") config.theming.wallpaper.diashow.active.wallpapers)})
					SELECT_COMMAND="${config.theming.wallpaper.diashow.selectCommand}"
					DELAY=${toString config.theming.wallpaper.diashow.delay}
					
					if [ ''${#WALLPAPERS[@]} -eq 0 ]; then
						echo "No wallpapers configured"
						exit 1
					fi
					
					while true; do
						# Select random wallpaper from the list
						RANDOM_INDEX=$((RANDOM % ''${#WALLPAPERS[@]}))
						SELECTED_WALLPAPER="''${WALLPAPERS[$RANDOM_INDEX]}"
						WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED_WALLPAPER"
						
						if [ -f "$WALLPAPER_PATH" ]; then
							echo "Setting wallpaper: $WALLPAPER_PATH"
							# Replace <wallpaperPath> placeholder with actual path
							COMMAND="''${SELECT_COMMAND//<wallpaperPath>/$WALLPAPER_PATH}"
							eval "$COMMAND"
						else
							echo "Warning: Wallpaper file not found: $WALLPAPER_PATH"
						fi
						
						sleep $DELAY
					done
				'';
			in wallpaperScript;
		};
	


		# Create a simple script that users can run manually if needed
		environment.systemPackages = with pkgs; [
			(writeShellScriptBin "wallpaper-diashow-control" ''
				#!/bin/bash
				
				case "$1" in
					start)
						echo "Starting wallpaper diashow service..."
						systemctl --user start wallpaper-diashow
						;;
					stop)
						echo "Stopping wallpaper diashow service..."
						systemctl --user stop wallpaper-diashow
						;;
					restart)
						echo "Restarting wallpaper diashow service..."
						systemctl --user restart wallpaper-diashow
						;;
					status)
						systemctl --user status wallpaper-diashow
						;;
					*)
						echo "Usage: $0 {start|stop|restart|status}"
						exit 1
						;;
				esac
			'')
		];
	};
	
}