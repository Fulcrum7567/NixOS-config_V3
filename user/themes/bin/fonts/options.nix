{ config, lib, ... }:	
{
	options.theming.fonts = {

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available fonts.";
		};

		monospace = {
			config = lib.mkOption {
				type = lib.types.enum (config.theming.fonts.available or []);
				description = "Set the font for monospace uses";
			};

			package = lib.mkOption {
				type = lib.types.package;
				description = "Package of the monospace font package. Is set by the font config.";
			};

			name = lib.mkOption {
				type = lib.types.str;
				description = "Name of the monospace font. Is set by the font config.";
			};
		};

		sansSerif = {
			config = lib.mkOption {
				type = lib.types.enum (config.theming.fonts.available or []);
				description = "Set the font for sans serif uses";
			};

			package = lib.mkOption {
				type = lib.types.package;
				description = "Package of the sans serif font package. Is set by the font config.";
			};

			name = lib.mkOption {
				type = lib.types.str;
				description = "Name of the sans serif font. Is set by the font config.";
			};
		};

		serif = {
			config = lib.mkOption {
				type = lib.types.enum (config.theming.fonts.available or []);
				description = "Set the font for serif uses";
			};

			package = lib.mkOption {
				type = lib.types.package;
				description = "Package of the serif font package. Is set by the font config.";
			};

			name = lib.mkOption {
				type = lib.types.str;
				description = "Name of the serif font. Is set by the font config.";
			};
		};

		sizes = {
			applications = lib.mkOption {
				type = lib.types.int;
				description = "Sets the size of the font in applications.";
				default = 12;
			};

			terminal = lib.mkOption {
				type = lib.types.int;
				description = "Sets the size of the font in the terminal.";
				default = 15;
			};
			

			desktop = lib.mkOption {
				type = lib.types.int;
				description = "Sets the size of the font on the desktop.";
				default = 10;
			};

			popups = lib.mkOption {
				type = lib.types.int;
				description = "Sets the size of the font in popups.";
				default = 10;
			};


		};

		
	};
}