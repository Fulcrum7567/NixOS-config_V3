{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		
		environment.systemPackages = with pkgs-default; [
			v4l-utils
		];

		programs.adb.enable = true;

        boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

        boot.kernelModules = [ "v4l2loopback" ];
        
	};
} 
