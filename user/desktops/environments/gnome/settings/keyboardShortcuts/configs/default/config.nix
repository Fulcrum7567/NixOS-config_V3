{ config, lib, settings, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};
in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/desktop/wm/keybindings" = {
					activate-window-menu = [];
					always-on-top = [ "<Shift><Super>t" ];
					begin-move = [];
					begin-resize = [];
					close = [ "<Super>q" ];
					cycle-group = [ "<Super>Tab" ];
					cycle-group-backward = [ "<Shift><Super>Tab" ];
					cycle-panels = [];
					cycle-panels-backward = [];
					cycle-windows = [];
					cycle-windows-backward = [];
					minimize = [];
					move-to-monitor-down = [ "<Alt><Super>Down" ];
					move-to-monitor-left = [ "<Alt><Super>Left" ];
					move-to-monitor-right = [ "<Alt><Super>Right" ];
					move-to-monitor-up = [ "<Alt><Super>Up" ];
					move-to-workspace-1 = [ "<Shift><Super>1" ];
					move-to-workspace-2 = [ "<Shift><Super>2" ];
					move-to-workspace-3 = [ "<Shift><Super>3" ];
					move-to-workspace-4 = [ "<Shift><Super>4" ];
					move-to-workspace-5 = [ "<Shift><Super>5" ];
					move-to-workspace-6 = [ "<Shift><Super>6" ];
					move-to-workspace-7 = [ "<Shift><Super>7" ];
					move-to-workspace-8 = [ "<Shift><Super>8" ];
					move-to-workspace-9 = [ "<Shift><Super>9" ];

					move-to-workspace-left = [ "<Shift><Super>Left" ];
					move-to-workspace-right = [ "<Shift><Super>Right" ];
					show-desktop = [ "<Super>d" ];
					switch-applications = [];
					switch-applications-backward = [];
					switch-input-source = [];
					switch-input-source-backward = [];
					switch-panels = [];
					switch-panels-backward = [];
					switch-to-workspace-1 = [ "<Control><Super>1" ];
					switch-to-workspace-2 = [ "<Control><Super>2" ];
					switch-to-workspace-3 = [ "<Control><Super>3" ];
					switch-to-workspace-4 = [ "<Control><Super>4" ];
					switch-to-workspace-5 = [ "<Control><Super>5" ];
					switch-to-workspace-6 = [ "<Control><Super>6" ];
					switch-to-workspace-7 = [ "<Control><Super>7" ];
					switch-to-workspace-8 = [ "<Control><Super>8" ];
					switch-to-workspace-9 = [ "<Control><Super>9" ];

					switch-to-workspace-left = [ "<Control><Super>Left" ];
					switch-to-workspace-right = [ "<Control><Super>Right" ];
					switch-windows = [ "<Alt>Tab" ];
					switch-windows-backward = [ "<Shift><Alt>Tab" ];
					toggle-fullscreen = [ "F11" ];
					toggle-maximized = [];
					toggle-on-all-workspaces = [ "<Control><Super>t" ];
				};

				"org/gnome/settings-daemon/plugins/media-keys" = {
					control-center = [ "<Super>i" ];
					home = [ "<Super>e" ];
			    };

			    "org/gnome/shell/keybindings" = {
			    	focus-active-notification = [ "<Shift><Super>n" ];
					screenshot = [ "<Shift><Control><Super>s" ];
					screenshot-window = [ "<Shift><Alt><Super>s" ];
					show-screen-recording-ui = [];
					show-screenshot-ui = [ "<Shift><Super>s" ];
					toggle-message-tray = [ "<Super>n" ];
			    };
			    
			};
		};
	};
} 
