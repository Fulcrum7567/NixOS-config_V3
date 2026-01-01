{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "tlp")) {

		services.power-profiles-daemon.enable = false;

		# 2. Enable TLP (The Power User Solution)
		services.tlp = {
			enable = true;
			settings = {
				# --- SECTION A: CRASH PREVENTION (Method 1) ---
				# Disabling Turbo Boost on battery prevents the sudden voltage spikes
				# that cause your old battery to force-shutdown the laptop.
				CPU_BOOST_ON_AC = 1;
				CPU_BOOST_ON_BAT = 0;

				# --- SECTION B: "BALANCED" FEEL ---
				# AC: Unrestricted performance
				CPU_SCALING_GOVERNOR_ON_AC = "performance";
				CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
				
				# BAT: "Balanced" setup. 
				# "powersave" governor allows frequency scaling (it doesn't mean "slow")
				# "balance_power" EPP hint tells the CPU to prefer efficiency but boost if needed.
				CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
				CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

				# --- SECTION C: CHARGING LIMITS ---
				# Keeps battery between 75% and 80% to extend lifespan.
				# Note: Support depends on hardware (Works on ThinkPad, Framework, many ASUS/Dells)
				START_CHARGE_THRESH_BAT0 = 75;
				STOP_CHARGE_THRESH_BAT0 = 80;
				
				# If you have a secondary internal battery (rare, but possible)
				# START_CHARGE_THRESH_BAT1 = 75;
				# STOP_CHARGE_THRESH_BAT1 = 80;

				# WiFi Power Saving
				WIFI_PWR_ON_AC = "off";
				WIFI_PWR_ON_BAT = "on";

				# PCIe Active State Power Management
				PCIE_ASPM_ON_AC = "default";
				PCIE_ASPM_ON_BAT = "powersupersave";

				# Runtime Power Management for PCI devices
				RUNTIME_PM_ON_AC = "auto";
				RUNTIME_PM_ON_BAT = "auto";

				# On Battery: Force "quiet" (lowest power/fan noise)
				PLATFORM_PROFILE_ON_BAT = "quiet";
				
				# On AC: "balanced" is usually enough, use "performance" only if gaming
				PLATFORM_PROFILE_ON_AC = "balanced";

				# USB Autosuspend
				USB_AUTOSUSPEND = 1;
			};
		};


	};
} 
