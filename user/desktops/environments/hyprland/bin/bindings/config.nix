{ config, lib, ... }:
let
  keyMap = {
		"<sep>" = ", ";

		"<super>" = "SUPER";
		"<shift>" = "SHIFT";
		"<alt>" = "ALT";
		"<ctrl>" = "Control_L";
		"<space>" = "SPACE";

		"<tab>" = "TAB";

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

  home-manager.users.${config.user.settings.username} = lib.mkIf (config.desktopEnvironments.hyprland.bin.bindings.enable && config.desktopEnvironments.hyprland.bin.bindings.enableAutoMapping) {
    wayland.windowManager.hyprland.settings = {

      bind = [

				# Windows
				# No always on top, no minimize
				"${config.custom.shortcuts.map keyMap config.shortcuts.windows.toggleFloating}, togglefloating"
				"${config.custom.shortcuts.map keyMap config.shortcuts.windows.pseudoTile}, pseudo"
				"${config.custom.shortcuts.map keyMap config.shortcuts.windows.toggleSplit}, togglesplit"



				# Move to monitor
				# No monitor up/down
				"${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToMonitorLeft}, movewindow, mon:-1"
				"${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToMonitorRight}, movewindow, mon:+1"
				
				# Move to workspace
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace1}, movetoworkspace, 1"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace2}, movetoworkspace, 2"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace3}, movetoworkspace, 3"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace4}, movetoworkspace, 4"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace5}, movetoworkspace, 5"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace6}, movetoworkspace, 6"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace7}, movetoworkspace, 7"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace8}, movetoworkspace, 8"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace9}, movetoworkspace, 9"

				#"${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspaceLeft}, movetoworkspace, -1"
				#"${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspaceRight}, movetoworkspace, +1"

				
				# Applications
        "${config.custom.shortcuts.map keyMap config.shortcuts.apps.close}, killactive"
				# No switch/switch backward
				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.switchToAppLeft}, movefocus, l"
				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.switchToAppRight}, movefocus, r"
				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.switchToAppUp}, movefocus, u"
				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.switchToAppDown}, movefocus, d"
				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.fullscreen}, fullscreen"
				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.activeOnAllWorkspaces}, pin"
				# No launch settings
				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.launchExplorer}, exec, ${config.packages.defaults.explorer.launchCommand}"
				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.launchTerminal}, exec, ${config.packages.defaults.terminal.launchCommand}"
				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.launchBrowser}, exec, ${config.packages.defaults.browser.launchCommand}"
				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.launchAppLauncher}, exec, ${config.packages.defaults.appLauncher.launchCommand}"

				# Workspaces
				"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspace1}, workspace, 1"
				"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspace2}, workspace, 2"
				"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspace3}, workspace, 3"
				"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspace4}, workspace, 4"
				"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspace5}, workspace, 5"
				"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspace6}, workspace, 6"
				"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspace7}, workspace, 7"
				"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspace8}, workspace, 8"
				"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspace9}, workspace, 9"

				
        #"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspaceLeft}, workspace, e-1"
				#"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspaceRight}, workspace, e+1"
				
				# DE
				# No show desktop, lock screen, screenshot, quick screenshot, quick screenshot window, focus active notification, open Notification panel

      ];
    };
	};
}