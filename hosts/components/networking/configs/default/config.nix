{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		networking.wireless = {
			enable = true;

			networks = {
				"Obi Wlan Kenobi 5GHz" = {
					pskRaw = "dc17a708c048642dfce8e96376d476b9001c11956567990af0cd522b58d1754c";
				};

			};

		};
		

	};
} 
