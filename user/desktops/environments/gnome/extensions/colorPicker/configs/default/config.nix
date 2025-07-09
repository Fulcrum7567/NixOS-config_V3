{ config, lib, settings, ... }:
let
	extensionConfig = config.desktopEnvironments.gnome.extensions.${settings.optionName};
in

{
	config = lib.mkIf (extensionConfig.enable && (extensionConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {lib, ... }: {
			dconf.settings = {

				"org/gnome/shell/extensions/color-picker" = {
					color-picker-shortcut = [ "<Shift><Super>c" ];
					enable-format = true;
					enable-notify = true;
					enable-shortcut = true;
					enable-systray = false;
					notify-style = lib.hm.gvariant.mkUint32 1;
					preview-style = lib.hm.gvariant.mkUint32 0;
			    };
			    
			};
		};
	};
} 
