{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};

	restartWaybar = if config.packages.waybar.enable then "waybar &" else "";
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {


		home-manager.users.${config.user.settings.username} = {
			services.hypridle.settings = {
				general = {
					after_sleep_cmd = "hyprctl dispatch dpms on";
					ignore_dbus_inhibit = false;
					lock_cmd = config.packages.defaults.lockscreen.launchCommand;
				};

				listener = [] ++ (if config.packages.${settings.optionName}.lockTimeout != null then [
					{
						timeout = config.packages.${settings.optionName}.lockTimeout;
						on-timeout = config.packages.defaults.lockscreen.launchCommand;
					}
				] else []) ++ (if config.packages.${settings.optionName}.dimScreenTimeout != null then [
					{
						timeout = config.packages.${settings.optionName}.dimScreenTimeout;
						on-timeout = "brightnessctl get > /tmp/previous_brightness && echo 0 > /tmp/reset_brightness && while [ $(brightnessctl get) -gt 0 -a $(cat /tmp/reset_brightness) -ne 1 ]; do brightnessctl -q set 1%-; sleep 0.02; done && echo 0 > /tmp/reset_brightness";
						on-resume = "echo 1 > /tmp/reset_brightness && brightnessctl set $(cat /tmp/previous_brightness)";
					}
				] else []) ++ (if config.packages.${settings.optionName}.sleepTimeout != null then [
					{
						timeout = config.packages.${settings.optionName}.sleepTimeout;
						on-timeout = "hyprctl dispatch dpms off";
						on-resume = "hyprctl dispatch dpms on";#; ${restartWaybar}"; Fixed?
					}
				] else []) ++ (if (config.host.settings.suspendWorking && (config.packages.${settings.optionName}.suspendTimeout != null)) then [
					{
						timeout = config.packages.${settings.optionName}.suspendTimeout;
						on-timeout = "systemctl suspend";
					}
				] else []);
			};
		};
	};
}
