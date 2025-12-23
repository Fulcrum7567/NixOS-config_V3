{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "custom1")) {

		packages.waybar.modules = {
			cava = {
				enable = true;
				activeConfig = "slyHarvey";
			};
			hyprland = {
				workspaces = {
					enable = true;
					activeConfig = "slyHarvey";
				};

				window = {
					enable = true;
					activeConfig = "slyHarvey";
				};
			};
			mpris = {
				enable = true;
				activeConfig = "slyHarvey";
			};
			
			clock = {
				enable = true;
				activeConfig = "slyHarvey";
			};

			network = {
				enable = true;
				activeConfig = "custom1";
			};

			bluetooth = {
				enable = true;
				activeConfig = "slyHarvey";
			};

			pulseaudio = {
				enable = true;
				activeConfig = "slyHarvey";
			};
			tray = {
				enable = true;
				activeConfig = "slyHarvey";
			};

			battery = {
				enable = true;
				activeConfig = "custom1";
			};
		};

		home-manager.users.${config.user.settings.username} = {
			programs.waybar = {
				enable = true;
				settings.mainBar = {
					layer = "top";
					position = "top";
					mode = "dock";
					height = 32; # 35
					exclusive = true;
					passthrough = false;
					gtk-layer-shell = true;
					ipc = true;
					fixed-center = true;
					margin-top = 10;
					margin-left = 10;
					margin-right = 10;
					margin-bottom = 0;

					modules-left = [ "hyprland/workspaces" "cava" "hyprland/window" ];
					modules-center = [ "clock" "mpris" ];
					modules-right = [ "tray" "pulseaudio" "bluetooth" ] ++ (if (config.host.settings.systemType == "laptop") then [ "battery" ] else []) ++ [ "network" ];
				};
      };
		};
	};
} 
