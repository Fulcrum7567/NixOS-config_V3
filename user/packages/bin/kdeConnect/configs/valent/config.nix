{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "valent")) {
		programs.kdeconnect.package = pkgs-default.valent;


		# Define connected devices
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				# S23
				"ca/andyholmes/valent/device/5ce48006642c4106b12ce8b4ee2b1c94" = {
					paired = true;
				};

				
				"ca/andyholmes/valent/device/5ce48006642c4106b12ce8b4ee2b1c94/plugin/clipboard" = {
					auto-pull = true;
					auto-push = true;
				};
				

			};
		};
	};
} 
