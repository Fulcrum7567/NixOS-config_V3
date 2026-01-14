{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		warnings = [
			"No configuration for this device is selected. Please add a device configuration."
		];
	};
} 
