{ config, lib, pkgs, ... }:
{
	config.stylix.cursor = lib.mkIf (config.theming.activeTheme != null) {
		name = config.theming.cursors.name;
		package = config.theming.cursors.package;
		size = config.theming.cursors.size;
	};
} 
