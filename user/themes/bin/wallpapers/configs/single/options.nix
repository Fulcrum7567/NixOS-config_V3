{ config, lib, ... }:
{
	
	config.theming.wallpaper.availableTypes = [ "single" ];

	options.theming.wallpaper.single = lib.mkIf (config.theming.wallpaper.type == "single") {
		active = lib.mkOption {
			type = lib.types.str;
			description = "Set the active wallpaper";
		};

		command = lib.mkOption {
			type = lib.types.str;
			description = "Command to set a single "
		};
	};	
} 
