{ config, lib, settings, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/mutter" = {
					edge-tiling = true;
					dynamic-workspaces = true;
					workspaces-only-on-primary = false;
					experimental-features = [ "scale-monitor-framebuffer" "xwayland-native-scaling" ];
				};
			    
			};
		};
	};
} 
