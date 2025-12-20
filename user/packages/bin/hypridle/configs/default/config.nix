{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};

	restartWaybar = if config.packages.waybar.enable then "waybar &" else "";
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		packages.hyprlock = lib.mkIf (option.lockCommand == "hyprlock") {
			enable = true;
		};

		home-manager.users.${config.user.settings.username} = {
			services.hypridle.settings = {
				general = {
					after_sleep_cmd = "hyprctl dispatch dpms on";
					ignore_dbus_inhibit = false;
					lock_cmd = config.packages.${settings.optionName}.lockCommand;
				};

				listener = [
					{
						timeout = config.packages.${settings.optionName}.lockTimeout;
						on-timeout = config.packages.${settings.optionName}.lockCommand;
					}
					{
						timeout = config.packages.${settings.optionName}.sleepTimeout;
						on-timeout = "hyprctl dispatch dpms off";
						on-resume = "hyprctl dispatch dpms on";#; ${restartWaybar}"; Fixed?
					}
				];
			};
		};
	};
}
