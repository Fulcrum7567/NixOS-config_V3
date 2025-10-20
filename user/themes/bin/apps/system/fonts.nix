{ config, lib, ... }:
{
	config = lib.mkIf ((config.theming.activeTheme != null) && (config.theming.useStylix == false)) {
		fonts.fontconfig.defaultFonts = {
			monospace = [ config.theming.fonts.monospace.name ];
			sansSerif = [ config.theming.fonts.sansSerif.name ];
			serif = [ config.theming.fonts.serif.name ];
		};

		home-manager.users.${config.user.settings.username} = {
			home.sessionVariables = {
				XCURSOR_THEME = config.theming.cursors.name;
			};
		};
	};
} 
