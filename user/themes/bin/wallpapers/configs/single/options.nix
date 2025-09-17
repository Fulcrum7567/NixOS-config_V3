{ config, lib, ... }:
{
	
	config.theming.wallpaper.availableTypes = [ "single" ];

	options.theming.wallpaper = {
		active = lib.mkOption {
			type = lib.types.path;
			default = null;
			description = "Set the active wallpaper";
		};
	};
} 
