{ config, lib, ... }:
{
	options.theming = {
		activeTheme = lib.mkOption {
			type = lib.types.str;
			description = "Set the theme to apply. Must exist in user/themes/profiles/.";
		};

		themeIsActive = {
			type = lib.types.bool;
			default = false;
			description = "Option to check whether a valid theme was selected. Is beeing set by the theme.";
		};
	};

} 
