{ config, lib, ... }:
{
	config = {
		fonts.fontconfig.defaultFonts = {
			monospace = [ config.theming.fonts.monospace.name ];
			sansSerif = [ config.theming.fonts.sansSerif.name ];
			serif = [ config.theming.fonts.serif.name ];
		};
	};
} 
