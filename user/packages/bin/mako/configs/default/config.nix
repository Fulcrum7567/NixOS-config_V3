{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			services.mako = {
				settings = {
					default-timeout = 5000;
					anchor = "top-right";
				};
			};
		};
	};
} 
