{ config, lib, settings, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gtk/gtk4/settings/file-chooser" = {
					show-hidden = true;
					fts-enabled = false;
					migrated-gtk-settings = true;
					search-filter-time-type = "last_modified";
				};
			    
			};
		};
	};
} 
