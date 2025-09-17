{ config, lib, ... }:
{

	options.theming.wallpaper = {

		groupType = lib.mkOption {
			type = lib.types.submodule;
			default = {
				name = lib.mkOption {
					type = lib.types.str;
					description = "Name of the wallpaper group.";
					example = "My first wallpaper collection";
				};

				wallpapers = lib.mkOption {
					type = lib.types.listOf lib.types.str;
					description = "A list of wallpapers.";
					example = [ "wallpaper1" "wallpaper2" ];
				};
			};
		};

		availableGroups = lib.mkOption {
			type = lib.types.listOf config.theming.wallpaper.groupType;
			default = [];
			description = "Groups of wallpapers."; 
		};

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
