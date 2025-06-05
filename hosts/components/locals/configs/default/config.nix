{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};

	english = "en_GB.UTF-8";
	german = "de_DE.UTF-8";
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		time.timeZone = "Europe/Berlin";
		i18n.defaultLocale = english;
		i18n.extraLocaleSettings = {
			LC_NUMERIC = english;

			LC_ADDRESS = german;
			LC_IDENTIFICATION = german;
			LC_MEASSUREMENT = german;
			LC_MONETARY = german;
			LC_NAME = german;
			LC_PAPER = german;
			LC_TELEPHONE = german;
			LC_TIME = german;
		};

	};
} 
