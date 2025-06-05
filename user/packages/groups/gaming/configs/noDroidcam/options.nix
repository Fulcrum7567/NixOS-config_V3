{ config, lib, settings, ... }:
{
	config.groups.${settings.optionName}.available = [ "noDroidcam" ];
} 
