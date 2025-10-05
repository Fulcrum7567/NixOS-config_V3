{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "RX500Series")) {


		environment.variables = {
			ROC_ENABLE_PRE_VEGA = "1";
		};

		hardware.graphics = {
			enable = true;
			enable32Bit = true;
		};


	};
} 
