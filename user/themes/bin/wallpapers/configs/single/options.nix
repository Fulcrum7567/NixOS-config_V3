{ config, lib, ... }:
{
	
	config.theming.wallpaper.availableTypes = [ "single" ];

	options.theming.wallpaper.single = {
		active = lib.mkOption {
			type = lib.types.str;
			default = null;
			description = "Set the active wallpaper";
		};
	};
} 
