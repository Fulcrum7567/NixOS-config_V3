{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.groups.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.active == "default")) {
		packages = {
			groups = {
				programming.enable = true;
			};	

			docker.enable = false;
			obsidian.enable = true;
			anki.enable = true;
		};
	};
} 
