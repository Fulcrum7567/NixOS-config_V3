{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};

	english = "en_GB.UTF-8";
	german = "de_DE.UTF-8";
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		home-manager.users.${config.user.settings.username} = {
			home.keyboard = {
				layout = "de";
			};
  	};

		services.xserver = {
			enable = lib.mkDefault true;
			xkb.layout = "de";
			xkb.variant = "";
	  };
		console.keyMap = "de";

	};
} 
