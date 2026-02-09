{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, inputs, ... }:
{
	nixpkgs.overlays = [
		(final: prev: {
			star-citizen-eac-fixed = prev.runCommand "star-citizen-eac-fixed-${inputs.nix-citizen.packages.${pkgs-default.stdenv.hostPlatform.system}.star-citizen.version}" {
				buildInputs = [ prev.makeWrapper ];
			} ''
				mkdir -p $out/bin
				
				# Create wrapper script with EAC fixes
				makeWrapper ${inputs.nix-citizen.packages.${pkgs-default.stdenv.hostPlatform.system}.star-citizen}/bin/star-citizen \
					$out/bin/star-citizen \
					--set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT "true" \
					--set-default WINEDLLOVERRIDES "icuuc=b;icuin=b;winemenubuilder.exe=d;nvapi=n;nvapi64=n" \
					--run 'detect_eac() {
						local prefix="''${WINEPREFIX:-$HOME/Games/star-citizen}"
						local game_base="$prefix/drive_c/Program Files/Roberts Space Industries/StarCitizen"
						for channel in LIVE PTU EPTU; do
							local eac_dir="$game_base/$channel/EasyAntiCheat"
							if [ -d "$eac_dir" ]; then
								export EAC_LAUNCHERDIR="C:\\Program Files\\Roberts Space Industries\\StarCitizen\\$channel\\EasyAntiCheat"
								return 0
							fi
						done
					}; detect_eac'
			'';
		})
	];
}
