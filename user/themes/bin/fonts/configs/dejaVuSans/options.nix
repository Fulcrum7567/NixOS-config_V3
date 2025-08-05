{ config, lib, settings, ... }:
let
	font = config.theming.fonts;
in
{
	config.theming.fonts.available = [ settings.optionName ];

	options.theming.fonts.${settings.optionName}.active = lib.mkOption {
		type = lib.types.bool;
		default = ((font.monospace.config == settings.optionName) ||
					(font.sansSerif.config == settings.optionName) ||
					(font.serif.config == settings.optionName));
		description = "Whether font is used and thus has to be installed.";
	};
} 
