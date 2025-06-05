{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.groups.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.active == "default")) {
		packages = {
			discord.enable = true;
			droidcam.enable = true;
			heroic.enable = true;
			lutris.enable = true;
			mangohud.enable = true;
			minecraft.enable = true;
			protonup.enable = true;
			steam.enable = true;
		};
	};
} 
