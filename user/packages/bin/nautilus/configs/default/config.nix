{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/nautilus/preferences" = {
					default-folder-viewer = "list-view";
				};
			    
			};
		};

		services.gvfs.enable = true;

		# Enable UDisks2 - Required for mounting USB drives/removable media
		services.udisks2.enable = true;

		# Enable dconf - Required for saving Nautilus settings and associations
		programs.dconf.enable = true;
		
		# Optional: Better thumbnail support for Nautilus
		services.tumbler.enable = true;

		programs.nautilus-open-any-terminal = {
			enable = true;
			terminal = config.packages.defaults.terminal.active;
		};

		# improve startup times
		systemd.user.services.nautilus-background = {
			description = "Nautilus Background Service";
			
			# NixOS uses 'wantedBy' instead of 'Install.WantedBy'
			wantedBy = [ "graphical-session.target" ];
			after = [ "graphical-session.target" ];

			# Actual service settings go inside 'serviceConfig'
			serviceConfig = {
				ExecStart = "${pkgs-default.nautilus}/bin/nautilus --gapplication-service";
				Restart = "on-failure";
				# Resource limits (optional)
				CPUQuota = "20%";
				MemoryHigh = "500M";
			};
		};
	};
} 
