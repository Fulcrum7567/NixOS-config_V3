{ config, lib, settings, ... }:
{
	config.theming.components.${settings.optionName}.availableTypes = [ "single" ];
} 
