{ config, lib, ... }:	
{
	options.theming.icons = {

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available icons.";
		};

		
		active = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.theming.icons.available or []));
			description = "Selects the icons of the theme";
		};

		package = lib.mkOption {
			type = lib.types.nullOr lib.types.package;
			description = "package of the icons. Is set by the icon config.";
		};

		name = lib.mkOption {
			type = lib.types.nullOr lib.types.str;
			description = "Name of the icons in the package. Is set by the icon config.";
		};

		
	};
}