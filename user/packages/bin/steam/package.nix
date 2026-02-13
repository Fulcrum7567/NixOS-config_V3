{ config, lib, pkgs, pkgs-default, pkgs-stable, pkgs-unstable, settings, inputs, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		nixpkgs.overlays = [ inputs.millennium.overlays.default ];

		# Package installation
		programs.steam = {
			enable = true;
			package = pkgs.millennium-steam;
		};
		
		environment.systemPackages = with pkgs-default; [
	  		steam-run
			libva
			libva-utils
			mesa
			vulkan-tools
		];
	};
}