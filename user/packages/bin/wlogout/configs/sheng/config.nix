{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "sheng")) {
		packages.toybox.enable = true; # make sure killall is available
		home-manager.users.${config.user.settings.username} = {
			programs.wlogout = {
				layout = [
					{
							"label" = "lock";
							"action" = "killall wlogout && sleep 0.15 && sh $HOME/Scripts/lockscreen";
							"text" = "Lock";
							"keybind" = "l";
					}
					{
							"label" = "hibernate";
							"action" = "killall wlogout && sleep 0.25 && loginctl hibernate";
							"text" = "Hibernate";
							"keybind" = "h";
					}
					{
							"label" = "logout";
							"action" = "killall wlogout && sleep 0.25 && hyprctl dispatch exit";
							"text" = "Logout";
							"keybind" = "e";
					}
					{
							"label" = "shutdown";
							"action" = "killall wlogout && sleep 0.25 && loginctl poweroff";
							"text" = "Shutdown";
							"keybind" = "s";
					}
					{
							"label" = "suspend";
							"action" = "killall wlogout && sleep 0.25 && loginctl suspend";
							"text" = "Suspend";
							"keybind" = "u";
					}
					{
							"label" = "reboot";
							"action" = "killall wlogout && sleep 0.25 && loginctl reboot";
							"text" = "Reboot";
							"keybind" = "r";
					}
				];
			};
		};
	};
} 
