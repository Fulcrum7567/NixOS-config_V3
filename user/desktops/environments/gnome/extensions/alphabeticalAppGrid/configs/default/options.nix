{ config, lib, settings, ... }:
{
	config.desktopEnvironments.gnome.extensions.${settings.optionName}.availableConfigs = [ "default" ];
} 
