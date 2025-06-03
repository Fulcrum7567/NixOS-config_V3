{ config, lib, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.dashToDock;
in
{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {
				
				"org/gnome/shell/extensions/dash-to-dock" = {
			      apply-custom-theme = false;
			      background-color = "rgb(36,31,49)";
			      background-opacity = 0.8;
			      click-action = "minimize";
			      custom-background-color = true;
			      custom-theme-customize-running-dots = false;
			      customize-alphas = true;
			      dash-max-icon-size = 48;
			      dock-position = "BOTTOM";
			      height-fraction = 0.9;
			      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
			      isolate-workspaces = true;
			      max-alpha = 0.7;
			      middle-click-action = "quit";
			      multi-monitor = true;
			      preview-size-scale = 0.0;
			      running-indicator-style = "DOTS";
			      scroll-action = "cycle-windows";
			      shift-click-action = "launch";
			      shift-middle-click-action = "launch";
			      shortcut = [];
			      shortcut-text = "";
			      show-apps-at-top = false;
			      show-mounts = false;
			      show-show-apps-button = true;
			      show-trash = false;
			      transparency-mode = "DYNAMIC";
			      blur = true;
			    };
			    
			};
		};
	};
} 
