{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "custom1")) {
		packages.hyprlock.enable = true; # lockscreen
		home-manager.users.${config.user.settings.username} = {
			programs.wlogout = {
				layout = [
					{
							"label" = "lock";
							"action" = config.packages.defaults.lockscreen.launchCommand;
							"text" = "Lock";
							"keybind" = "l";
					}
				]++ (if (config.host.settings.suspendWorking) then [
					{
							"label" = "suspend";
							"action" = "systemctl suspend";
							"text" = "Suspend";
							"keybind" = "u";
					} 
				] else []) ++ [
					{
							"label" = "shutdown";
							"action" = "systemctl poweroff";
							"text" = "Shutdown";
							"keybind" = "s";
					}
				] ++ (if (config.host.settings.hibernateWorking) then [
					{
							"label" = "hibernate";
							"action" = "systemctl hibernate";
							"text" = "Hibernate";
							"keybind" = "h";
					}
				] else []) ++  [
					{
							"label" = "logout";
							"action" = config.desktops.logoutCommand;
							"text" = "Logout";
							"keybind" = "e";
					}
					
				]  ++ [
					{
							"label" = "reboot";
							"action" = "systemctl reboot";
							"text" = "Reboot";
							"keybind" = "r";
					}
					{
						"label" = "rebootToFirmware";
						"action" = "systemctl reboot --firmware-setup";
						"text" = "Reboot to Firmware";
						"keybind" = "f";
					}
				];
			};
		};
	};
} 
