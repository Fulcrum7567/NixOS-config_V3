{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		services.flatpak.update.onActivation = true;

		services.flatpak.update.auto = {
			enable = true;
			onCalendar = "weekly";
		};
	};
} 
