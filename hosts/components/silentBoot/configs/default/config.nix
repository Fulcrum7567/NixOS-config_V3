{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		boot = {
			consoleLogLevel = 3;
			initrd.verbose = false;
			kernelParams = [
				"quiet"
				"splash"
				"boot.shell_on_fail"
				"udev.log_priority=3"
				"rd.systemd.show_status=auto"
			];

			loader = lib.mkIf option.hideMenu {
				timeout = 0;
			};
		};

	};
} 
