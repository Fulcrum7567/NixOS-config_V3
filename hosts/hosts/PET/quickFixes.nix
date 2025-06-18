/*
	Quick, ugly fixes not meant to keep


*/
{ lib, config, ... }:
{
	config = {
		services.desktopManager.gnome.enable = true;
		services.displayManager.gdm.enable = true;
	};



}