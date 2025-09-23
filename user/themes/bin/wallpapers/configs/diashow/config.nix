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

		systemd.user.services.wallpaper-diashow = lib.mkIf (config.theming.wallpaper.type == "diashow") {
			description = "Wallpaper Diashow Service";
			wantedBy = [ "default.target" ];
			after = [ "graphical-session.target" ];
			
			# This ensures the service restarts when the configuration changes
			restartIfChanged = true;
			
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

		system.activationScripts.restartWallpaperService = lib.mkIf (config.theming.wallpaper.type == "diashow") {
			# This specifies the script's content.
			text = ''
				USER=${config.user.settings.username}

				# Get the User ID
				USER_UID=$(${pkgs.coreutils}/bin/id -u $USER)

				# Find the PID of the user's "systemd --user" instance
				USER_SYSTEMD_PID=$(${pkgs.procps}/bin/pgrep -u $USER_UID -f "systemd --user")

				# Safety check
				if [ -z "$USER_SYSTEMD_PID" ]; then
					echo "User $USER session not found, skipping user service restart."
					exit 0
				fi

				# Extract the necessary environment variables from the user's running session
				DBUS_ADDRESS=$(${pkgs.gnugrep}/bin/grep -z DBUS_SESSION_BUS_ADDRESS /proc/$USER_SYSTEMD_PID/environ | ${pkgs.coreutils}/bin/cut -d= -f2-)
				# --- NEW LINE ADDED HERE ---
				XDG_DIR=$(${pkgs.gnugrep}/bin/grep -z XDG_RUNTIME_DIR /proc/$USER_SYSTEMD_PID/environ | ${pkgs.coreutils}/bin/cut -d= -f2-)

				echo "Restarting wallpaper-diashow.service for user $USER..."

				# --- SUDO COMMANDS UPDATED HERE ---
				# Run the commands passing BOTH required variables into the environment
				${pkgs.sudo}/bin/sudo -u $USER \
					DBUS_SESSION_BUS_ADDRESS=$DBUS_ADDRESS \
					XDG_RUNTIME_DIR=$XDG_DIR \
					${pkgs.systemd}/bin/systemctl --user daemon-reload

				${pkgs.sudo}/bin/sudo -u $USER \
					DBUS_SESSION_BUS_ADDRESS=$DBUS_ADDRESS \
					XDG_RUNTIME_DIR=$XDG_DIR \
					${pkgs.systemd}/bin/systemctl --user restart wallpaper-diashow
			'';
		};

	};
}