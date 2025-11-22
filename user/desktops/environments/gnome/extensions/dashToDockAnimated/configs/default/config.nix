{ config, lib, settings, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.${settings.optionName};
in
{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/shell/extensions/dash2dock-lite" = {
					animation-bounce = 0.75;
					animation-magnify = 0.3;
					animation-rise = 0.25;
					animation-spread = 0.75;
					autohide-dash = true;
					autohide-speed = 0.4;
					blur-background = false;
					blur-resolution = 0;
					border-radius = 3.0;
					calendar-icon = false;
					clock-icon = false;
					customize-label = false;
					customize-topbar = false;
					debug-visual = false;
					dock-padding = 0.5892116182572614;
					edge-distance = 0.6022727272727273;
					favorites-only = false;
					icon-resolution = 0;
					icon-size = 0.20689655172413793;
					icon-spacing = 0.5;
					items-pullout-angle = 0.5;
					label-border-radius = 2.369747899159664;
					label-border-thickness = 3;
					max-recent-items = 2;
					msg-to-ext = "";
					multi-monitor-preference = 1;
					notification-badge-style = 5;
					open-app-animation = true;
					panel-mode = false;
					preferred-monitor = 0;
					pressure-sense = true;
					pressure-sense-sensitivity = 0.11;
					running-indicator-size = 2;
					running-indicator-style = 1;
					scroll-sensitivity = 0.11;
					separator-color = mkTuple [ 0.125490203499794 0.1411764770746231 0.1725490242242813 1.0 ];
					separator-thickness = 1;
					shrink-icons = true;
					topbar-border-thickness = 3;
			    };
			    
			};
		};
	};
} 
