{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {
				"net/nokyan/resources" = {
					apps-show-gpu-memory = true;
					graph-data-points = 60;
					is-maximized = true;
					last-viewed-page = "applications";
					network-bits = true;
					show-graph-grids = false;
					sidebar-description = true;
					sidebar-details = true;
				};
			};
		};
	};
} 
