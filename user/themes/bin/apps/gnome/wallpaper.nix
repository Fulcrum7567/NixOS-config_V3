{ lib, config, ... }:
{
	config.home-manager.users.${config.user.settings.username} = lib.mkIf ((config.theming.activeTheme != null) && !config.theming.useStylix) {
		dconf.settings = lib.mkIf (config.theming.wallpaper.type == "single") {
		    "org/gnome/desktop/background" = {
				picture-uri = "${toString config.theming.wallpaper.wallpaperPath}/${config.theming.wallpaper.single.active}";
				picture-uri-dark = "${toString config.theming.wallpaper.wallpaperPath}/${config.theming.wallpaper.single.active}";
	    	};
	    };
	};

}