{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.groups.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.active == "default")) {
		packages = {
			docker.enable = true;
			jetbrainsToolbox.enable = true;
			obsidian.enable = true;
		};
	};
} 
