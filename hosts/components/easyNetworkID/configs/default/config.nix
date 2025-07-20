{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		services.avahi = {
			enable = true;
			nssmdns4 = true;

			publish = {
				enable = true;
				addresses = true;
				workstation = true;
			};
		};

		networking.firewall.allowedUDPPorts = [ 5353 ];

	};
} 
