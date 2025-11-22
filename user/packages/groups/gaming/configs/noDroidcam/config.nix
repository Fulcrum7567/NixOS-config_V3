{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.groups.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.active == "noDroidcam")) {
		packages = {
			nixcord.enable = true;
			heroic.enable = true;
			lutris.enable = true;
			mangohud.enable = true;
			minecraft.enable = true;
			protonup.enable = true;
			steam.enable = true;
		};
	};
} 
