{ config, lib, ... }:
{

	options.theming.wallpaper = {

		wallpaperPath = lib.mkOption {
			type = lib.types.path;
			default = ./bin;
			description = "Path to stored wallpapers.";
		};

		availableTypes = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [ ];
			apply = x: lib.unique x;
			description = "List of all available wallpaper types";
		};

		type = lib.mkOption {
			type = lib.types.enum (config.theming.wallpaper.availableTypes or []);
			description = "What type of wallpaper";
		};

	};
}
