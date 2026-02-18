{ config, lib, settings, ... }:
{
	config.desktopEnvironments.gnome.settings.${settings.optionName}.availableConfigs = [ "default" ];
} 
