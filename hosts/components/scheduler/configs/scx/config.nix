{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "scx")) {

		services.scx = {
			enable = (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.12");
			package = pkgs-default.scx.rustscheds;
			scheduler = "scx_lavd";
		};

		assertions = [
			{
				assertion = (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.12");
				message = "Trying to use scx scheduler on unsupported kernel version. Minimum required version is 6.12.\nSet config.hosts.components.${settings.optionName}.activeConfig to another value or disable the component.";
			}
		];

	};
} 
