{ config, lib, settings, ... }:
{
	options.theming.components.${settings.optionName} = {

		availableTypes = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available configs for the ${settings.displayName} component.";
		};

		type = lib.mkOption {
			type = lib.types.enum (config.theming.components.${settings.optionName}.availableTypes or []);
			default = "single"; # A default config should always exist, delete if not
			description = "Set the active wallpaper type.";
		};

		active = lib.mkOption {
			type = lib.types.str;
			description = "Path, realtive to .../components/wallpapers/bin/";
			example = "nord/nixos.png";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable ${settings.displayName} components.";
		};
	};
}