{ lib, config, ... }:
{
	config.home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.gnome.wallpaper.override) {
		dconf.settings = {
		    "org/gnome/desktop/background" = {
				picture-uri = "${toString config.theming.wallpaper.wallpaperPath}/${config.theming.gnome.wallpaper.single.active}";
				picture-uri-dark = "${toString config.theming.wallpaper.wallpaperPath}/${config.theming.gnome.wallpaper.single.active}";
	    	};
	    };
	};

}