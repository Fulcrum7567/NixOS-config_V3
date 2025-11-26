{ config, lib, ... }:
let 
	cfg = config.theming.gnome;
in 
{
	options.theming.gnome = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = (config.theming.activeTheme != null);
			description = "Enable GNOME theming support.";
		};
		useStylix = lib.mkOption {
			type = lib.types.bool;
			default = cfg.enable && config.theming.useStylix;
			description = "Whether to use Stylix for theming GNOME.";
		};


		accentColor = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "slate" "blue" "purple" "pink" "red" "orange" "yellow" "green" "teal" ]);
			default = null;
			description = "The accent color to use for GNOME.";
		};


		cursor = {
			override = lib.mkOption {
				type = lib.types.bool;
				default = cfg.enable && !cfg.useStylix;
				description = "Whether to override GNOME cursor theme settings.";
			};
			cursor-theme = lib.mkOption {
				type = lib.types.str;
				default = config.theming.cursors.name;
				description = "The name of the GNOME cursor theme to use.";
			};
		};


		polarity = {
			override = lib.mkOption {
				type = lib.types.bool;
				default = cfg.enable && !cfg.useStylix;
				description = "Whether to override GNOME color scheme settings.";
			};
			value = lib.mkOption {
				type = lib.types.enum [ "prefer-dark" "prefer-light" "default" ];
				default = (if (config.theming.polarity == "dark") then "prefer-dark" else (if (config.theming.polarity == "light") then "prefer-light" else "default"));
				description = "The GNOME color scheme to use.";
			};
		};

		wallpaper = {
			override = lib.mkOption {
				type = lib.types.bool;
				default = cfg.enable && !cfg.useStylix && (config.theming.wallpaper.type == "single");
				description = "Whether to override GNOME wallpaper settings.";
			};

			value = lib.mkOption {
				type = lib.types.str;
				default = config.theming.wallpaper.single.active;
				description = "The type of wallpaper setting to use for GNOME (single, slideshow, etc.).";
			};
		};
	};
}