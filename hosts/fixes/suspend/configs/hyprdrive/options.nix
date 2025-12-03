{ config, lib, settings, ... }:
{
	config.hosts.fixes.${settings.optionName}.availableConfigs = [ "hyprdrive" ];
} 
