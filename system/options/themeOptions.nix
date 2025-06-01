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
	};

} 
