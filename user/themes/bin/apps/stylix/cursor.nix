{ config, lib, pkgs, ... }:
{
	config.stylix.cursor = {
		name = config.theming.cursors.name;
		package = config.theming.cursors.package;
		size = config.theming.cursors.size;
	};
} 
