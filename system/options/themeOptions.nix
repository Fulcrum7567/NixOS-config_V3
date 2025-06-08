{ config, lib, ... }:
{
	options.theming = {

		availableThemes = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available themes. Every theme adds itself to this list.";
		};

		activeTheme = lib.mkOption {
			type = lib.types.enum (config.theming.availableThemes or []);
			description = "Set the theme to apply. Must exist in user/themes/profiles/.";
		};

		polarity = lib.mkOption {
			type = lib.types.enum [
				"dark"
				"light"
				"mixed"
			];
			description = "Set the polarity of the theme";
			example = "dark";
		};

		availableColorSchemes = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available color schemes.";
		};

		colorScheme = lib.mkOption {
			type = lib.types.enum (config.theming.availableColorSchemes or []);
			description = "Set the color scheme of the theme";
		};
	};

} 
