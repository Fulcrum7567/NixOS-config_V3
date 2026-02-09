{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, inputs, ... }:
let
	# Create a wrapped version of star-citizen with EAC fixes
	# Based on PR #101: https://github.com/LovingMelody/nix-citizen/pull/101
	star-citizen-eac-fixed = pkgs-default.writeShellScriptBin "star-citizen" ''
		# EAC 70003 Fix: ICU DLL overrides for .NET 7+ compatibility
		export WINEDLLOVERRIDES="icuuc=b;icuin=b;''${WINEDLLOVERRIDES}"
		
		# EAC 70003 Fix: Bypass incomplete Wine ICU implementation
		export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true
		
		# EAC 70003 Fix: Auto-detect EAC launcher directory for wine-astral's timeout patch
		export WINEPREFIX="''${WINEPREFIX:-$HOME/Games/star-citizen}"
		game_base="$WINEPREFIX/drive_c/Program Files/Roberts Space Industries/StarCitizen"
		for channel in LIVE PTU EPTU; do
			eac_dir="$game_base/$channel/EasyAntiCheat"
			if [ -d "$eac_dir" ]; then
				export EAC_LAUNCHERDIR="C:\\Program Files\\Roberts Space Industries\\StarCitizen\\$channel\\EasyAntiCheat"
				break
			fi
		done
		
		# Launch the actual star-citizen with fixes applied
		exec ${inputs.nix-citizen.packages.${pkgs-default.stdenv.hostPlatform.system}.star-citizen}/bin/star-citizen "$@"
	'';
in
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		nix.settings = {
			substituters = ["https://nix-gaming.cachix.org" "https://nix-citizen.cachix.org"];
			trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="];
		};
		
		
		environment.systemPackages = [
			star-citizen-eac-fixed
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