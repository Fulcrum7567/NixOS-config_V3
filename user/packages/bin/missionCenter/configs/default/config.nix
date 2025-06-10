{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"io/missioncenter/MissionCenter" = {
					apps-page-sorting-column = "Cpu";
					apps-page-sorting-order = "Descending";
					performance-page-network-dynamic-scaling = true;
					performance-selected-page = "gpu-0000:00:02.0";
					performance-show-cpu = true;
					performance-show-disks = true;
					performance-show-fans = true;
					performance-show-gpus = true;
					performance-show-memory = true;
					performance-show-network = true;
					performance-sidebar-hidden-graphs = "net-br-4be9d488d64a;net-br-015f4d991c52;net-docker0;net-br-ef06c9cbbcc1";
					performance-sidebar-order = "cpu;gpu-0000:00:02.0;memory;disk-nvme0n1;net-br-015f4d991c52;net-br-4be9d488d64a;net-br-ef06c9cbbcc1;net-docker0;net-wlo1;fan-7-1;fan-7-2";
					performance-smooth-graphs = true;
					window-height = 400;
					window-selected-page = "performance-page";
					window-width = 600;
				};
			    
			};
		};

		
	};
} 
