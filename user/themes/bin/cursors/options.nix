{ config, lib, ... }:	
{
	options.theming.cursors = {

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available cursors.";
		};

		
		active = lib.mkOption {
			type = lib.types.enum (config.theming.cursors.available or []);
			description = "Selects the cursor of the theme";
		};

		package = lib.mkOption {
			type = lib.types.package;
			description = "package of the cursor. Is set by the cursor config.";
		};

		name = lib.mkOption {
			type = lib.types.str;
			description = "Name of the cursor in the package. Is set by the cursor config.";
		};

		
	};
}