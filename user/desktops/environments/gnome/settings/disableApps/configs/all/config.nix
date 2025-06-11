{ config, lib, settings, inputs, pkgs-default, pkgs, pkgs-stable, pkgs-unstable, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "all")) {
		
		services.gnome.core-apps.enable = false;

		services.xserver.desktopManager.xterm.enable = false;
		services.xserver.excludePackages = [ pkgs-default.xterm ];

		documentation.nixos.enable = false;
	};
} 
