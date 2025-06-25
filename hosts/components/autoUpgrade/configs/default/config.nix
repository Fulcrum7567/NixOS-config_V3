{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		system.autoUpgrade = {
			enable = true;
			flake = host.settings.dotfilesDir;
			operation = "switch";
			dates = option.interval;
			randomizedDelaySec = "10min";
			allowReboot = false;
		};

	};
} 
