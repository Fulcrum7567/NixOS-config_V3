{ config, lib, ... }:
{
	
	config.theming.wallpaper.availableTypes = [ "diashow" ];

	options.theming.wallpaper.diashow = {
		active = lib.mkOption {
			type = lib.types.nullOr lib.customTypes.wallpaperGroup;
			default = null;
			description = "Set the active wallpaper group";
		};

		serviceNeeded = lib.mkOption {
			type = lib.types.bool;
			default = true;
			description = "Whether the diashow wallpaper type needs a service to run.";
		};

		additionalPackages = lib.mkOption {
			type = lib.types.listOf lib.types.package;
			default = [  ];
			description = "Additional packages needed for the diashow wallpaper type.";
		};

		selectCommand = lib.mkOption {
			type = lib.types.nullOr lib.types.str;
			default = null;
			description = "Command to set a wallpaper. Should be set by the DE.";
			example = "gsettings set org.gnome.desktop.background picture-uri-dark '<wallpaperPath>'";
		};

		delay = lib.mkOption {
			type = lib.types.int;
			default = 300;
			description = "Delay between wallpaper changes in seconds.";
		};
	};
} 
