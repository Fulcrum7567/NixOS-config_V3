{ config, lib, ... }:
{
	
	config.theming.wallpaper.availableTypes = [ "diashow" ];

	options.theming.wallpaper.diashow = {
		active = lib.mkOption {
			type = lib.types.nullOr lib.customTypes.wallpaperGroup;
			default = null;
			description = "Set the active wallpaper group";
		};

		selectCommand = lib.mkOption {
			type = lib.types.nullOr lib.types.str;
			default = null;
			description = "Command to set a wallpaper. Should be set by the DE.";
			example = "gsettings set org.gnome.desktop.background picture-uri-dark '<wallpaperPath>'";
		};
	};
} 
