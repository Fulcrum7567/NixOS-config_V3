{ config, lib, ... }:
let 
	cfg = config.theming.gtk;
in 
{
  options.theming.gtk = {
    	enable = lib.mkOption {
			type = lib.types.bool;
			default = (config.theming.activeTheme != null);
			description = "Enable gtk theming support.";
		};
		useStylix = lib.mkOption {
			type = lib.types.bool;
			default = cfg.enable && config.theming.useStylix;
			description = "Whether to use Stylix for theming gtk.";
		};

		colors = {
			override = lib.mkOption {
				type = lib.types.bool;
				default = cfg.enable && !cfg.useStylix;
				description = "Whether to override gtk color scheme settings.";
			};
			value = lib.mkOption {
				type = lib.types.str;
				default = builtins.readFile ./defaultCss.css;
				description = "The gtk css to use.";
			};
		};

		cursor = {
			override = lib.mkOption {
				type = lib.types.bool;
				default = cfg.enable && !cfg.useStylix;
				description = "Whether to override gtk cursor theme settings.";
			};

			value = {
				name = lib.mkOption {
					type = lib.types.str;
					default = config.theming.cursors.name;
					description = "The name of the gtk cursor theme to use.";
				};
				package = lib.mkOption {
					type = lib.types.nullOr lib.types.package;
					default = config.theming.cursors.package;
					description = "The package of the gtk cursor theme to use.";
				};
				size = lib.mkOption {
					type = lib.types.int;
					default = config.theming.cursors.size;
					description = "The size of the gtk cursor theme to use.";
				};
			};
		};


		fonts = {
			override = lib.mkOption {
				type = lib.types.bool;
				default = cfg.enable && !cfg.useStylix;
				description = "Whether to override gtk font settings.";
			};

			value = {
				sansSerif = {
					package = lib.mkOption {
						type = lib.types.package;
						default = config.theming.fonts.sansSerif.package;
						description = "Package of the sans serif font.";
					};
					name = lib.mkOption {
						type = lib.types.str;
						default = config.theming.fonts.sansSerif.name;
						description = "Name of the sans serif font.";
					};
				};

				monospace = {
					package = lib.mkOption {
						type = lib.types.package;
						default = config.theming.fonts.monospace.package;
						description = "Package of the monospace font.";
					};
					name = lib.mkOption {
						type = lib.types.str;
						default = config.theming.fonts.monospace.name;
						description = "Name of the monospace font.";
					};
				};

				sizes = {
					applications = lib.mkOption {
						type = lib.types.int;
						default = config.theming.fonts.sizes.applications;
						description = "Sets the size of the font in applications.";
					};
				};
			};
		};

		theme = {
			override = lib.mkOption {
				type = lib.types.bool;
				default = cfg.enable && !cfg.useStylix;
				description = "Whether to override gtk theme settings.";
			};

			value = {
				package = lib.mkOption {
					type = lib.types.package;
					default = null;
					description = "Package providing the GTK theme the GTK theme is based on.";
				};

				name = lib.mkOption {
					type = lib.types.str;
					default = "Adwaita-dark";
					description = "Theme the GTK theme is based on.";
				};
			};
		};

		icons = {
			override = lib.mkOption {
				type = lib.types.bool;
				default = cfg.enable && !cfg.useStylix;
				description = "Whether to override gtk icon theme settings.";
			};

			value = {
				package = lib.mkOption {
					type = lib.types.package;
					default = config.theming.icons.package;
					description = "Package providing the GTK icon theme.";
				};

				name = lib.mkOption {
					type = lib.types.str;
					default = config.theming.icons.name;
					description = "GTK icon theme to use.";
				};
			};
		};


		polarity = {
			override = lib.mkOption {
				type = lib.types.bool;
				default = cfg.enable && !cfg.useStylix;
				description = "Whether to override gtk color scheme settings.";
			};
			value = lib.mkOption {
				type = lib.types.enum [ "0" "1" ];
				default = (if (config.theming.polarity == "dark") then "1" else "0");
				description = "The gtk color scheme to use.";
			};
		};


  	};
}