{ config, lib, settings, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.${settings.optionName};
in
{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/shell/extensions/clipboard-indicator" = {
					disable-down-arrow = true;
					history-size = 30;
					keep-selected-on-clear = true;
					display-mode = 0;
					paste-button = false;
					move-item-first = true;
					preview-size = 32;
					strip-text = true;
					toggle-menu = [ "<Super>v" ];
			    };

			    
			};
		};
	};
} 
