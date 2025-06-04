{ config, lib, settings, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/nautilus/preferences" = {
					default-folder-viewer = "list-view";
				};
			    
			};
		};
	};
} 
