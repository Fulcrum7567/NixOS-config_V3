{ config, lib, pkgs, ... }:
{
	config.stylix.fonts = {
		
		monospace = {
			name = config.theming.fonts.monospace.name;
			package = config.theming.fonts.monospace.package;
		};

		sansSerif = {
			name = config.theming.fonts.sansSerif.name;
			package = config.theming.fonts.sansSerif.package;
		};

		serif = {
			name = config.theming.fonts.serif.name;
			package = config.theming.fonts.serif.package;
		};

		sizes = {
			applications = config.theming.fonts.sizes.applications;
			desktop = config.theming.fonts.sizes.desktop;
			terminal = config.theming.fonts.sizes.terminal;
			popups = config.theming.fonts.sizes.popups;
		};

	};
} 
