{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			wayland.windowManager.hyprland.settings =  {
				bind = [
					"SUPERControl_L, Left, exec, hyprnome --previous"
					"SUPERControl_L, Right, exec, hyprnome"
					"SUPERSHIFT, Left, exec, hyprnome --previous --move"
					"SUPERSHIFT, Right, exec, hyprnome --move"
				];
			};
		};
	};
} 
