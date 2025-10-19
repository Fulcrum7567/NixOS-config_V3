{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {


		programs.nix-ld = {
			enable = true;
			libraries = with pkgs-default; [
				# Add any required libraries for unpacked binaries here
			];
		};


	};
} 
