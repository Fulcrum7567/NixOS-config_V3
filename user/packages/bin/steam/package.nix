{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		# Package installation
		programs.steam.enable = true;
		
		environment.systemPackages = with pkgs-default; [
	  		steam-run
			libva
			libva-utils
			mesa
			vulkan-tools
		];
	};
}