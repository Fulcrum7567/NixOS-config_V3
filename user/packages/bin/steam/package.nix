{ config, lib, pkgs, pkgs-default, pkgs-stable, pkgs-unstable, settings, inputs, ... }:
let
	cfg = config.packages.${settings.optionName};
in
{
	config = lib.mkIf cfg.enable {

		nixpkgs.overlays = [ inputs.millennium.overlays.default ];

		# Package installation
		programs.steam = {
			enable = true;
			package = {
				"default" = pkgs-default.steam;
				"stable" = pkgs-stable.steam;
				"unstable" = pkgs-unstable.steam;
				"millennium" = pkgs.millennium-steam;
			}."${cfg.package}";
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