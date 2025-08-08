{ config, lib, pkgs, ... }:
{
	config.stylix = {
		enable = config.theming.useStylix;
		base16Scheme = config.colorScheme.palette;
		autoEnable = true;


		polarity = (if (config.theming.polarity == "mixed") then "either" else config.theming.polarity);
	};
} 
