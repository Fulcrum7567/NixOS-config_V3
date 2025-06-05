{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.fixes.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		services.udev.packages = with pkgs-default; [ libinput ];
  		services.libinput.enable = true;
		boot.kernelModules = [ "hid-multitouch" "i2c-hid" ]; 

	};
} 
