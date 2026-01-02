{ config, lib, settings, ... }:
{
	config.hosts.components.${settings.optionName}.availableConfigs = [ "ppd" ];


} 
