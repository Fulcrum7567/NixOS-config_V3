{ config, lib, ... }:
let
  keyMap = {
		"<sep>" = ", ";

		"<super>" = "SUPER";
		"<shift>" = "SHIFT";
		"<alt>" = "ALT";
		"<ctrl>" = "Control_L";

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

  home-manager.users.${config.user.settings.username} = lib.mkIf config.desktopEnvironments.hyprland.bin.bindings.enable {
    wayland.windowManager.hyprland.settings = {

      bind = [

        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace1}, movetoworkspace, 1"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace2}, movetoworkspace, 2"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace3}, movetoworkspace, 3"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace4}, movetoworkspace, 4"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace5}, movetoworkspace, 5"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace6}, movetoworkspace, 6"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace7}, movetoworkspace, 7"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace8}, movetoworkspace, 8"
        "${config.custom.shortcuts.map keyMap config.shortcuts.windows.moveToWorkspace9}, movetoworkspace, 9"

        "${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspaceLeft}, workspace, e+1"
				"${config.custom.shortcuts.map keyMap config.shortcuts.workspaces.switchToWorkspaceRight}, workspace, e-1"

        "${config.custom.shortcuts.map keyMap config.shortcuts.apps.close}, killactive"


				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.launchTerminal}, exec, ${config.packages.defaults.terminal.active}"
				"${config.custom.shortcuts.map keyMap config.shortcuts.apps.launchBrowser}, exec, ${config.packages.defaults.browser.active}"
      ];
    };
	};
}