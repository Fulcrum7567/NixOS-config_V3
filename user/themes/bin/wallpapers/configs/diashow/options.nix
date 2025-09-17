{ config, lib, ... }:
{
	
	config.theming.wallpaper.availableTypes = [ "diashow" ];

	options.theming.wallpaper.diashow = {
		active = lib.mkOption {
			type = config.theming.wallpaper.groupType;
			default = null;
			description = "Set the active wallpaper group";
		};
	};
} 
