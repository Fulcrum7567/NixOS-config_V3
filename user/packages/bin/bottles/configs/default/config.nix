{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {
				"com/usebottles/bottles" = {
					auto-close-bottles = true;
					notifications = true;
					show-sandbox-warning = false;
					startup-view = "page_list";
					steam-proton-support = true;
					temp = true;
					update-date = false;
				}
			}
		};
	};
} 
