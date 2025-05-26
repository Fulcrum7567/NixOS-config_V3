{ lib, hostSettingsRaw, ... }:
let 
	stateType = lib.types.enum [
		"stable"
		"unstable"
	];
in
{

	options.host.settings = {
		# System type
		system = lib.mkOption {
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
		systemState = lib.mkOption {
			type = stateType;
			default = hostSettingsRaw.systemState;
			description = "Set the state of the system. Should be the same as in hostSettingsRaw!";
			example = "stable";
		};


		# System type
		systemType = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [
				"desktop"
				"laptop"
				"convertible"
			]);
			default = "desktop";
			description = "Set the type of the device.";
		};


		# Default package state
		defaultPackageState = lib.mkOption {
			type = stateType;
			default = hostSettingsRaw.defaultPackageState;
			description = "Set the state packages should be in on default.";
		};


		# GPU manufacturer
		gpuManufacturer = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [
				"nvidia"
				"amd"
				"intel"
			]);
			default = lib.types.null;
			description = "Set what type of graphics card your system has.";
		};


		# Dotfiles dir
		dotfilesDir = lib.mkOption {
			type = lib.types.str;
			description = "Set where the dotfiles are stored on your host.";
		};

	};

	


	

}