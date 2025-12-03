{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.fixes.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		# Fix immediate suspend wake caused by GPP0 (Chipset/LAN Bridge)
		systemd.services.fix-suspend-gpp0 = {
			description = "Disable GPP0 wakeup to fix immediate suspend wake";
			wantedBy = [ "multi-user.target" ];
			serviceConfig = {
				Type = "oneshot";
				# We check if it is enabled before writing to avoid toggling it back on
				ExecStart = "/bin/sh -c 'if grep -q \"GPP0.*enabled\" /proc/acpi/wakeup; then echo GPP0 > /proc/acpi/wakeup; fi'";
			};
		};
	};
} 
