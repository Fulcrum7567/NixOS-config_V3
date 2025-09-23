{ config, lib, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.gnomeBase.enable {
		services.desktopManager.gnome.enable = true;
		theming = {
			useStylix = true;

			wallpaper.diashow.selectCommand = "gsettings set org.gnome.desktop.background picture-uri-dark '<wallpaperPath>'";
		};
	};
}