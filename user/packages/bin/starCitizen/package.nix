{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, inputs, ... }:
{

	imports = [
		inputs.nix-citizen.nixosModules.default
	];

	config = lib.mkIf config.packages.${settings.optionName}.enable {

		nix.settings = {
			substituters = ["https://nix-gaming.cachix.org" "https://nix-citizen.cachix.org"];
			trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="];
		};
		
		programs.rsi-launcher = {
			# Enables the star citizen module
			enable = true;
			# Additional commands before the game starts
			/*
			preCommands = ''
				export DXVK_HUD=compiler;
				export MANGO_HUD=1;
			'';
			*/

			gamescope.enable = false;

			umu.enable = false;
		};
		

		zramSwap = {
			enable = true;
			algorithm = "zstd";
			memoryPercent = 30;
		};
	};
}