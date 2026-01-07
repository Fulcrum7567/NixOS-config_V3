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
							"action" = "sleep 1 && ${config.packages.defaults.lockscreen.launchCommand}";
							"text" = "Lock";
							"keybind" = "l";
					}
				] ++ [
					{
							"label" = "shutdown";
							"action" = "systemctl poweroff";
							"text" = "Shutdown";
							"keybind" = "s";
					}
				] ++ (if (config.host.settings.suspendWorking) then [
					{
							"label" = "suspend";
							"action" = "systemctl suspend";
							"text" = "Suspend";
							"keybind" = "u";
					} 
				] else []) ++ [
					{
							"label" = "reboot";
							"action" = "systemctl reboot";
							"text" = "Reboot";
							"keybind" = "r";
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
