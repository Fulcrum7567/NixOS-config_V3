{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "sheng")) {
		packages.hyprlock.enable = true; # lockscreen
		home-manager.users.${config.user.settings.username} = {
			programs.wlogout = {
				layout = [
					{
							"label" = "lock";
							"action" = "pkill wlogout && sleep 0.15 && hyprlock";
							"text" = "Lock";
							"keybind" = "l";
					}
					{
							"label" = "hibernate";
							"action" = "pkill wlogout && sleep 0.25 && systemctl hibernate";
							"text" = "Hibernate";
							"keybind" = "h";
					}
					{
							"label" = "logout";
							"action" = "pkill wlogout && sleep 0.25 && hyprctl dispatch exit";
							"text" = "Logout";
							"keybind" = "e";
					}
					{
							"label" = "shutdown";
							"action" = "pkill wlogout && sleep 0.25 && systemctl poweroff";
							"text" = "Shutdown";
							"keybind" = "s";
					}
					{
							"label" = "suspend";
							"action" = "pkill wlogout && sleep 0.25 && systemctl suspend";
							"text" = "Suspend";
							"keybind" = "u";
					}
					{
							"label" = "reboot";
							"action" = "pkill wlogout && sleep 0.25 && systemctl reboot";
							"text" = "Reboot";
							"keybind" = "r";
					}
				];
			};
		};
	};
} 
