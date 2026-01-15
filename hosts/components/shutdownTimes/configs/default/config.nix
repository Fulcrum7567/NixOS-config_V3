{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, sops-nix, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		systemd.services.daily-power-cycle = {
			description = "Shutdown at ${option.shutdownAt} and wake up at ${option.wakeUpAt}";
			
			# This automatically creates a systemd timer to run the service at 10 PM
			startAt = option.shutdownAt; 
			
			# Ensure the service runs with root privileges (required for rtcwake)
			serviceConfig = {
				Type = "oneshot";
				User = "root";
			};

			# The script to execute
			script = ''
				# 1. Calculate the timestamp (in seconds) for tomorrow at ${option.wakeUpAt}
				WAKEUP_TIME=$(${pkgs-default.coreutils}/bin/date -d "tomorrow ${option.wakeUpAt}" +%s)

				# 2. Log the action (visible in journalctl)
				echo "Setting RTC wake alarm for $(date -d @$WAKEUP_TIME) and powering off..."

				# 3. Set the alarm and shutdown
				# -m off: Power off the machine completely (S5 state)
				# -t: Wake up at the specific epoch time calculated above
				${pkgs-default.util-linux}/bin/rtcwake -m off -t $WAKEUP_TIME
			'';
		};
		

	};
} 
