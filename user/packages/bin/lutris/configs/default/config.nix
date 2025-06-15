{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		hardware.graphics.enable32Bit = true;

		home-manager.users.${config.user.settings.username} = {
			
		};
	};
} 
