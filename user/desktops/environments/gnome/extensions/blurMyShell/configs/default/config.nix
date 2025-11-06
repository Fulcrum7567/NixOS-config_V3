{ config, lib, settings, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.${settings.optionName};

	extensionPath = "org/gnome/shell/extensions/blur-my-shell";
in

with lib.hm.gvariant;
{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"${extensionPath}" = {
					settings-version = 2;
				};

				"${extensionPath}/appfolder" = {
					brightness = 0.6;
					sigma = 30;
				};

				"${extensionPath}/applications" = {
					blacklist = [ "Plank" "com.desktop.ding" "Conky" "kitty" ];
					blur = false;
					blur-on-overview = false;
					dynamic-opacity = false;
					enable-all = false;
				};

				"${extensionPath}/coverflow-alt-tab" = {
					pipeline = "pipeline_default";
				};

				"${extensionPath}/dash-to-dock" = {
					blur = false;
					brightness = 0.6;
					pipeline = "pipeline_default_rounded";
					sigma = 30;
					static-blur = true;
					style-dash-to-dock = 0;
				};

				"${extensionPath}/lockscreen" = {
					pipeline = "pipeline_default";
				};

				"${extensionPath}/overview" = {
					blur = true;
					pipeline = "pipeline_default";
				};

				"${extensionPath}/panel" = {
					brightness = 0.6;
					force-light-text = false;
					override-background = true;
					override-background-dynamically = false;
					pipeline = "pipeline_default";
					sigma = 30;
					static-blur = true;
					style-panel = 0;
					unblur-in-overview = true;
				};

				"${extensionPath}/screenshot" = {
					pipeline = "pipeline_default";
				};

				"${extensionPath}/window-list" = {
					brightness = 0.6;
					sigma = 30;
				};
			    
			};
		};
	};
} 
