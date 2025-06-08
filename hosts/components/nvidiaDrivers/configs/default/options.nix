{ config, lib, settings, ... }:
{
	config.hosts.components.${settings.optionName}.availableConfigs = [ "default" ];

	
} 
