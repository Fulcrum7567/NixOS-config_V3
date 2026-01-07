{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		environment.systemPackages = with pkgs-default; [
			android-tools
		];

		boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

		boot.kernelModules = [ "v4l2loopback" ];

		boot.extraModprobeConfig = ''
			options v4l2loopback exclusive_caps=1
		'';

		
        
	};
} 
