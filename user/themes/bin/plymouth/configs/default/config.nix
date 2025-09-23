{ config, lib, inputs, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
{
	config = lib.mkIf (config.theming.plymouth.activeTheme == "default") {

		boot.plymouth = {
			enable = true;
			theme = "breeze";
		};
	};
}