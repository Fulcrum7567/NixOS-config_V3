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

		baseGTKTheme = {

			package = lib.mkOption {
				type = lib.types.nullOr lib.types.package;
				default = null;
				description = "Package providing the GTK theme the GTK theme is based on.";
			};

			name = lib.mkOption {
				type = lib.types.str;
				default = "Adwaita-dark";
				description = "Theme the GTK theme is based on.";
			};
		};

		baseQtTheme = {
			package = lib.mkOption {
				type = lib.types.nullOr lib.types.package;
				default = null;
				description = "Package providing the Qt theme the Qt theme is based on.";
			};
			
			name = lib.mkOption {
				type = lib.types.str;
				default = (if (config.theming.polarity == "light") then "adwaita" else "adwaita-dark");
				description = "Theme the Qt theme is based on.";
			};
		};

		overrideThemeColors = lib.mkOption {
			type = lib.types.bool;
			default = true;
			description = "Whether to override theme colors.";
		};

		gnomeAccentColor = lib.mkOption {
			type = lib.types.enum [
				"blue"
				"teal"
				"green"
				"yellow"
				"orange"
				"red"
				"pink"
				"purple"
				"slate"
			];
			default = "blue";
			description = "Selects the accent color of gnome.";
		};

		useStylix = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to use stylix to theme programs. Might break things (like Plasma 6). Should be set by DEs for example.";
		};
	};
} 
