/*
	Quick, ugly fixes not meant to keep


*/
{ lib, config, pkgs, ... }:
{
	config = {
		home-manager.users.fulcrum.xdg.configFile."gtk-4.0/settings.ini".source = pkgs.writeText "gtk-4.0-settings.ini" ''
			[Settings]
			gtk-theme-name = Adwaita
			gtk-icon-theme-name = Adwaita
			gtk-font-name = Cantarell 11
			gtk-cursor-theme-name = Adwaita
			gtk-cursor-theme-size = 24
		'';
	};
}