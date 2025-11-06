{ config, pkgs, pkgs-unstable, lib, ... }:
{
	config = {

		#nix-diff
		environment.systemPackages = with pkgs; [
			nix-diff
		];
		
		programs.alvr = {
			enable = true;
			openFirewall = true;
		};

		hardware.graphics = {
			enable = true;
			enable32Bit = true;
		};

		boot.kernelParams = [
			"video=DP-3:2560x1440@144"
			"video=HDMI-A-1:1920x1080@60"
		];






		# Ollama
		services.ollama = {
			enable = false;
			acceleration = "cuda";
			models = "/mnt/HDD/AI/Ollama/Models";
			loadModels = [
				"deepseek-r1:70b"
			];
		};

		home-manager.users.${config.user.settings.username} = {

			/*
			wayland.windowManager.hyprland.settings = {	
				workspace = [
					"1, monitor:DP-2"
					"2, monitor:DP-2"
					"3, monitor:DP-2"
					"4, monitor:DP-2"
					"5, monitor:DP-2"
					"6, monitor:DP-2"
					"7, monitor:DP-2"
					"8, monitor:DP-2"
					"9, monitor:DP-2"
					"10, monitor:DP-2"

					"11, monitor:HDMI-A-2"
					"12, monitor:HDMI-A-2"
					"13, monitor:HDMI-A-2"
					"14, monitor:HDMI-A-2"
					"15, monitor:HDMI-A-2"
					"16, monitor:HDMI-A-2"
					"17, monitor:HDMI-A-2"
					"18, monitor:HDMI-A-2"
					"19, monitor:HDMI-A-2"
					"20, monitor:HDMI-A-2"
				];

				bind = [

					"SUPER CONTROL, 1, workspace, 1"
					"SUPER CONTROL, 1, exec, hyprctl dispatch workspace 11"
					"SUPER CONTROL, 2, workspace, 2"
					"SUPER CONTROL, 2, exec, hyprctl dispatch workspace 12"
					"SUPER CONTROL, 3, workspace, 3"
					"SUPER CONTROL, 3, exec, hyprctl dispatch workspace 13"
					"SUPER CONTROL, 4, workspace, 4"
					"SUPER CONTROL, 4, exec, hyprctl dispatch workspace 14"
					"SUPER CONTROL, 5, workspace, 5"
					"SUPER CONTROL, 5, exec, hyprctl dispatch workspace 15"
					"SUPER CONTROL, 6, workspace, 6"
					"SUPER CONTROL, 6, exec, hyprctl dispatch workspace 16"
					"SUPER CONTROL, 7, workspace, 7"
					"SUPER CONTROL, 7, exec, hyprctl dispatch workspace 17"
					"SUPER CONTROL, 8, workspace, 8"
					"SUPER CONTROL, 8, exec, hyprctl dispatch workspace 18"
					"SUPER CONTROL, 9, workspace, 9"
					"SUPER CONTROL, 9, exec, hyprctl dispatch workspace 19"
					"SUPER CONTROL, 0, workspace, 10"
					"SUPER CONTROL, 0, exec, hyprctl dispatch workspace 20"
					"SUPER CONTROL, right, workspace, +1"
					"SUPER CONTROL, right, exec, hyprctl dispatch workspace +1"

					# Switch to the previous workspace on both monitors
					"SUPER CONTROL, left, workspace, -1"
					"SUPER CONTROL, left, exec, hyprctl dispatch workspace -1"
				]; 
			};
			*/

			#switch audio
			dconf.settings = {
		        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
		            name = "Switch audio output";
		            command = "bash ${config.host.settings.dotfilesDir}/system/switchAudioOutput.sh";
		            binding = "<Control><Alt>KP_Left";
		        };

		        "org/gnome/settings-daemon/plugins/media-keys" = {
		            custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" ];
		        };
		    };
		};

	};
}
