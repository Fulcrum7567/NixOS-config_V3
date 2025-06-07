{ config, lib, settings, ... }:
{
	config.packages.groups.${settings.optionName}.available = [ "noDroidcam" ];
} 
