{ config, lib, settings, ... }:
{
	config.theming.components.${settings.optionName}.available = [ "aurebesh" ];
} 
