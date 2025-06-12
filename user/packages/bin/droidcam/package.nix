{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		# Package installation
		environment.systemPackages = with pkgs-default; [
	        droidcam
			v4l-utils
		];
	};
}