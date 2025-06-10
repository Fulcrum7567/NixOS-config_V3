{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.groups.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.active == "default")) {
		packages = {
			docker.enable = false;
			jetbrainsToolbox.enable = true;
			obsidian.enable = true;
		};
	};
} 
