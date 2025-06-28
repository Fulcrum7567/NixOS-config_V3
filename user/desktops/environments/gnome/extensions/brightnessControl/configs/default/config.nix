{ config, lib, settings, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.${settings.optionName};
in
{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			
			dconf.settings = {
				"org/gnome/shell/extensions/display-brightness-ddcutil" = {
					allow-zero-brightness = true;
					button-location = 1;
					ddcutil-binary-path = "/run/current-system/sw/bin/ddcutil";
					ddcutil-queue-ms = 130.0;
					ddcutil-sleep-multiplier = 40.0;
					decrease-brightness-shortcut = [ "<Super>Page_Down" ];
					hide-system-indicator = false;
					increase-brightness-shortcut = [ "<Super>Page_Up" ];
					position-system-indicator = 11.0;
					position-system-menu = 2.0;
					show-all-slider = false;
					show-sliders-in-submenu = false;
					step-change-keyboard = 2.0;
			    };
			};
			
		};
	};
} 
