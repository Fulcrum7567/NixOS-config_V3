{ config, lib, settings, ... }:
{
	config.hosts.components.${settings.optionName}.availableConfigs = [ "sync" ];

	options.hosts.components.${settings.optionName} = {

	};
} 
