{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		nix = {
			settings.auto-optimise-store = true;

			gc = {
				automatic = true;
				dates = option.interval;
				options = "--delete-older-than ${option.minDays}d";
			};
		};

	};
} 
