{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "ppd")) {

		# 1. Enable the Desktop Environment's Power Management
		# This keeps the slider in your UI and handles the "Logic" (scaling behavior)
		services.power-profiles-daemon.enable = true;

		services.system76-scheduler.settings.cfsProfiles.enable = true; # Better scheduling for CPU cycles - thanks System76!!!
    services.thermald.enable = true; # Enable thermald, the temperature management daemon. (only necessary if on Intel CPUs)

		# 2. The "Safety Net" - Udev Rules for Anti-Crash
		# These rules trigger immediately when power creates an event.
		services.udev.extraRules = lib.mkIf option.limitWattageOnBattery ''
			# When Unplugged (Battery Mode): Disable Turbo Boost to prevent crashing
			SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.bash}/bin/bash -c 'echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo'"
			
			# When Plugged In (AC Mode): Enable Turbo Boost for max performance
			SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.bash}/bin/bash -c 'echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo'"
		'';

		# Note: If you have an AMD CPU, change "intel_pstate" above to "cpufreq" 
		# and write to "/sys/devices/system/cpu/cpufreq/boost" (0 for off, 1 for on).

		# 3. Battery Charge Limiter (85%)
		# A simple service to set the limit at boot without needing the full TLP suite.
		systemd.services.battery-charge-threshold = lib.mkIf (option.chargeLimit != null) {
			description = "Set battery charge threshold to ${toString option.chargeLimit}%";
			wantedBy = [ "multi-user.target" ];
			startLimitBurst = 5;
			serviceConfig = {
				Type = "oneshot";
				Restart = "on-failure";
				ExecStart = pkgs.writeShellScript "set-charge-limit" ''
					# Try standard paths (works for most modern kernels/laptops)
					for bat in /sys/class/power_supply/BAT?; do
						# Try charge_control_end_threshold (ASUS, modern Linux std)
						if [ -f "$bat/charge_control_end_threshold" ]; then
							echo ${toString option.chargeLimit} > "$bat/charge_control_end_threshold"
						fi
						# Try charge_stop_threshold (ThinkPads)
						if [ -f "$bat/charge_stop_threshold" ]; then
							echo ${toString option.chargeLimit} > "$bat/charge_stop_threshold"
						fi
					done
				'';
			};
		};

	};
} 
