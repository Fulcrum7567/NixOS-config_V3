{ config, lib, settings, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.${settings.optionName};
in
{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/shell/extensions/blur-my-shell/appfolder" = {
			      	brightness = 0.6;
			      	sigma = 30;
			    };

			    "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
			      	pipeline = "pipeline_default";
			    };

			    
			    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
			      	pipeline = "pipeline_default";
			    };

			    "org/gnome/shell/extensions/blur-my-shell/overview" = {
			      	pipeline = "pipeline_default";
			    };

			    "org/gnome/shell/extensions/blur-my-shell/panel" = {
			      	brightness = 0.6;
			      	pipeline = "pipeline_default";
			      	sigma = 30;
			    };

			    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
			      	pipeline = "pipeline_default";
			    };

			    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
			      	brightness = 0.6;
			      	sigma = 30;
			    };
			    
			};
		};
	};
} 
