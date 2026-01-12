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
						on-timeout = "brightnessctl -s set 5%";
						on-resume = "brightnessctl -r";
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
