{ config, lib, settings, ... }:
{
	config.packages.${settings.optionName}.availableConfigs = [ "HyDE1" ];
} 
