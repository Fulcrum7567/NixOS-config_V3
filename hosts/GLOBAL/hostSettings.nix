{ lib, hostSettingsRaw, ... }:
let 
	stateType = lib.types.enum [
		"stable"
		"unstable"
	];
in
{
	# System type
	options.host.settings.system = lib.mkOption {
		type = lib.types.enum [ 
			"x86_64-linux"
			"x86_64-darwin"
			"aarch64-linux"
			"aarch64-darwin"
			"i686-linux"
		];
		default = hostSettingsRaw.system;
		description = "Set the type of system the machine is based on. Should be the same as in hostSettingsRaw!";
		example = "x86_64-linux";
	};


	# System state
	options.host.settings.systemState = lib.mkOption {
		type = stateType;
		default = hostSettingsRaw.systemState;
		description = "Set the state of the system. Should be the same as in hostSettingsRaw!";
		example = "stable";
	};


	# System type
	options.host.settings.systemType = lib.mkOption {
		type = lib.types.nullOr (lib.types.enum [
			"desktop"
			"laptop"
			"convertible"
		]);
		default = "desktop";
		description = "Set the type of the device.";
	};


	# Default package state
	options.host.settings.defaultPackageState = lib.mkOption {
		type = stateType;
		default = "stable";
		description = "Set the state packages should be in on default.";
	};


	# GPU manufacturer
	options.host.settings.gpuManufacturer = lib.mkOption {
		type = lib.types.nullOr (lib.types.enum [
			"nvidia"
			"amd"
			"intel"
		]);
		default = lib.types.null;
		description = "Set what type of graphics card your system has.";
	};


	

}