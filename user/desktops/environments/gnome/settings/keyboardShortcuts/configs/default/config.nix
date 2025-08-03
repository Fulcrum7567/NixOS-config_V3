{ config, lib, settings, ... }:
let
	settingsConfig = config.desktopEnvironments.gnome.settings.${settings.optionName};

	keyMap = {
		"<sep>" = "";

		"<super>" = "<Super>";
		"<shift>" = "<Shift>";
		"<alt>" = "<Alt>";
		"<ctrl>" = "<Control>";

		"<tab>" = "Tab";

		"<down>" = "Down";
		"<left>" = "Left";
		"<right>" = "Right";
		"<up>" = "Up";

		"<f1>" = "F1";
		"<f2>" = "F2";
		"<f3>" = "F3";
		"<f4>" = "F4";
		"<f5>" = "F5";
		"<f6>" = "F6";
		"<f7>" = "F7";
		"<f8>" = "F8";
		"<f9>" = "F9";
		"<f10>" = "F10";
		"<f11>" = "F11";
		"<f12>" = "F12";
	};


in
{
	config = lib.mkIf (settingsConfig.enable && (settingsConfig.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {

				"org/gnome/desktop/wm/keybindings" = {
					activate-window-menu = [];
					always-on-top = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.alwaysOnTop) ];
					begin-move = [];
					begin-resize = [];
					close = [ (config.custom.shortcuts.map keyMap config.shortcuts.apps.close) ];
					cycle-group = [ ];
					cycle-group-backward = [ ];
					cycle-panels = [];
					cycle-panels-backward = [];
					cycle-windows = [];
					cycle-windows-backward = [];
					minimize = [];
					move-to-monitor-down = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToMonitorDown) ];
					move-to-monitor-left = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToMonitorLeft) ];
					move-to-monitor-right = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToMonitorRight) ];
					move-to-monitor-up = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToMonitorUp) ];
					move-to-workspace-1 = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace1) ];
					move-to-workspace-2 = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace2) ];
					move-to-workspace-3 = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace3) ];
					move-to-workspace-4 = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace4) ];
					move-to-workspace-5 = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace5) ];
					move-to-workspace-6 = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace6) ];
					move-to-workspace-7 = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace7) ];
					move-to-workspace-8 = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace8) ];
					move-to-workspace-9 = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace9) ];

					move-to-workspace-left = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspaceLeft) ];
					move-to-workspace-right = [ (config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspaceRight) ];

					show-desktop = [ (config.custom.shortcuts.map keyMap config.shortcuts.de.showDesktop) ];
					switch-applications = [];
					switch-applications-backward = [];
					switch-input-source = [];
					switch-input-source-backward = [];
					switch-panels = [];
					switch-panels-backward = [];
					switch-to-workspace-1 = [ ];
					switch-to-workspace-2 = [ ];
					switch-to-workspace-3 = [ ];
					switch-to-workspace-4 = [ ];
					switch-to-workspace-5 = [ ];
					switch-to-workspace-6 = [ ];
					switch-to-workspace-7 = [ ];
					switch-to-workspace-8 = [ ];
					switch-to-workspace-9 = [ ];

					switch-to-workspace-left = [ (config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspaceLeft) ];
					switch-to-workspace-right = [ (config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspaceRight) ];
					switch-windows = [ (config.custom.shortcuts.map keyMap config.shortcuts.apps.switch) ];
					switch-windows-backward = [ (config.custom.shortcuts.map keyMap config.shortcuts.apps.switchBackward) ];
					toggle-fullscreen = [ (config.custom.shortcuts.map keyMap config.shortcuts.apps.fullscreen) ];
					toggle-maximized = [];
					toggle-on-all-workspaces = [ (config.custom.shortcuts.map keyMap config.shortcuts.apps.activeOnAllWorkspaces) ];
				};

				"org/gnome/settings-daemon/plugins/media-keys" = {
					control-center = [ (config.custom.shortcuts.map keyMap config.shortcuts.apps.launchSettings) ];
					home = [ (config.custom.shortcuts.map keyMap config.shortcuts.apps.launchExplorer) ];
			    };

			    "org/gnome/shell/keybindings" = {
			    	focus-active-notification = [ (config.custom.shortcuts.map keyMap config.shortcuts.de.focusActiveNotification) ];
					screenshot = [ (config.custom.shortcuts.map keyMap config.shortcuts.de.quickScreenshot) ];
					screenshot-window = [ (config.custom.shortcuts.map keyMap config.shortcuts.de.quickScreenshotWindow) ];
					show-screen-recording-ui = [];
					show-screenshot-ui = [ (config.custom.shortcuts.map keyMap config.shortcuts.de.screenshot) ];
					toggle-message-tray = [ (config.custom.shortcuts.map keyMap config.shortcuts.de.openNotificationPanel) ];
			    };
			    
			};
		};
	};
} 
