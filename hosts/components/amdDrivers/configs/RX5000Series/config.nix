{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "RX5000Series")) {

		boot.initrd.kernelModules = [ "amdgpu" ];
		services.xserver.enable = true;
		services.xserver.videoDrivers = [ "amdgpu" ];

		hardware.graphics.extraPackages = with pkgs; [
			rocmPackages.clr.icd
			clinfo
			amdvlk
		];

		environment.variables = {
			ROC_ENABLE_PRE_VEGA = "1";
		};

		hardware.graphics.enable32Bit = true;

		# For 32 bit applications 
		hardware.graphics.extraPackages32 = with pkgs; [
			driversi686Linux.amdvlk
		];



	};
} 
