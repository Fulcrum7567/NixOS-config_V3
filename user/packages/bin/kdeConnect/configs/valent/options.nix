{ config, lib, settings, ... }:
{
	config.packages.${settings.optionName}.availableConfigs = [ "valent" ];
} 
