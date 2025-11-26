{ config, lib, ... }:
{
	config = {
		stylix.targets.gnome.enable = config.theming.gnome.useStylix;
	};
} 
