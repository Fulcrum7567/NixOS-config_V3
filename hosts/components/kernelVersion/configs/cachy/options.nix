{ config, lib, settings, pkgs, ... }:
{
	config.hosts.components.${settings.optionName}.availableConfigs = [ "cachy" ];

	options.hosts.components.${settings.optionName}.cachy = {
		version = lib.mkOption {
			type = lib.types.attrs;
			default = (if (config.host.settings.systemType == "server") then pkgs.linuxPackages_cachyos-server else pkgs.linuxPackages_cachyos);
			description = "The kernel version to use for CachyOS systems.";
		};
	};
} 
