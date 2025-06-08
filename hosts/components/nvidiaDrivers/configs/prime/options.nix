{ config, lib, settings, ... }:
{
	config.hosts.components.${settings.optionName}.availableConfigs = [ "prime" ];

	options.hosts.components.${settings.optionName} = {

		intelBusId = lib.mkOption {
			type = lib.types.str;
			description = "Bus Id of the Intel CPU";
			example = "PCI:0:2:0";
		};

		nvidiaBusId = lib.mkOption {
			type = lib.types.str;
			description "Bus Id of the NVidia graphics card";
			example = "PCI:1:0:0";
		};
	};
} 
