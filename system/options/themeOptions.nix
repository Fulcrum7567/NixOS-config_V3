{ config, lib, ... }:
{
	options.theming = {
		activeTheme = lib.mkOption {
			type = lib.types.str;
			description = "Set the theme to apply. Must exist in user/themes/profiles/.";
		};

		isThemeActive = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Option to check whether a valid theme was selected. Is beeing set by the theme.";
		};
	};


	# Warning
	config = lib.mkIf (config.theming.isThemeActive == false) {
		warnings = [
			"No valid theme is set! Select one from user/themes/profiles and activate it with config.theming.activeTheme."
		];
	};

} 
