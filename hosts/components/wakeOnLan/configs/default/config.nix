{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};

in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		networking.interfaces.${option.interface}.wakeOnLan = {
			enable = true;
			policy = [ "magic" ];
		};

	};
} 
