{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, inputs, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		nix.settings = {
			substituters = ["https://nix-gaming.cachix.org" "https://nix-citizen.cachix.org"];
			trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="];
		};
		
		
		environment.systemPackages = [
			inputs.nix-citizen.packages.${pkgs-default.stdenv.hostPlatform.system}.rsi-launcher
		];
		

		zramSwap = {
			enable = true;
			algorithm = "zstd";
			memoryPercent = 30;
		};

		boot.kernel.sysctl = {
			"vm.max_map_count" = 16777216;
			"fs.file-max" = 524288;
		};
	};
}