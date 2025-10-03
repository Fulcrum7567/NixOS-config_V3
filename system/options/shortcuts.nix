{ lib, config, ... }:

let
	# Define the mapping function inside a let block. It's local to this
	# module unless we explicitly expose it via an option.
  	mappingFunction = keyMap: shortcut:
		let
			tokens = lib.attrNames keyMap;
		in
	    	lib.foldl'
		        (currentString: token:
					lib.replaceStrings [ token ] [ (lib.attrByPath [ token ] "" keyMap) ] currentString
		        )
			shortcut
			tokens;

in
{
	options = {
		# Your custom shortcuts options
		shortcuts = {

			/*
				Possible tokens for keyboard shortcuts:
				<sep>			: Separator between modifiers and keys (", " for hyprland)
				<super>			: Main modifier key (Windows key)
				<ctrl>			: Left-contorl
				<alt>			: Left-alt
				<shift>			: Left-shift
				<tab>			: Tabulator
				<space>			: Space bar

				<up>			: Arrow up
				<down>			: Arrow down
				<left>			: Arrow left
				<right>			: Arrow right

				<f1>			: F1
				<f2>			: F2
				<f3>			: F3
				<f4>			: F4
				<f5>			: F5
				<f6>			: F6
				<f7>			: F7
				<f8>			: F8
				<f9>			: F9
				<f10>			: F10
				<f11>			: F11
				<f12>			: F12


			*/

			# Windows

			windows = {

				alwaysOnTop = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>t";
					description = "Shortcut to keep window on top.";
				};

				minimize = lib.mkOption {
					type = lib.types.str;
					default = "";
					description = "Shortcut to minimize window.";
				};

				toggleFloating = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>v";
					description = "Shortcut to toggle floating mode for window.";
				};

				pseudoTile = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>p";
					description = "Shortcut to toggle pseudo tiling mode for window.";
				};

				toggleSplit = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>j";
					description = "Shortcut to toggle split mode for window.";
				};


				# Move to monitor

				moveToMonitorUp = lib.mkOption {
					type = lib.types.str;
					default = "<super><alt><sep><up>";
					description = "Shortcut to move window up one monitor.";
				};

				moveToMonitorDown = lib.mkOption {
					type = lib.types.str;
					default = "<super><alt><sep><down>";
					description = "Shortcut to move window down one monitor.";
				};

				moveToMonitorLeft = lib.mkOption {
					type = lib.types.str;
					default = "<super><alt><sep><left>";
					description = "Shortcut to move window left one monitor.";
				};

				moveToMonitorRight = lib.mkOption {
					type = lib.types.str;
					default = "<super><alt><sep><right>";
					description = "Shortcut to move window up one monitor.";
				};


				# Move to workspace

				moveToWorkspace1 = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>1";
					description = "Shortcut to move window to workspace 1.";
				};

				moveToWorkspace2 = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>2";
					description = "Shortcut to move window to workspace 2";
				};

				moveToWorkspace3 = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>3";
					description = "Shortcut to move window to workspace 3.";
				};

				moveToWorkspace4 = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>4";
					description = "Shortcut to move window to workspace 4.";
				};

				moveToWorkspace5 = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>5";
					description = "Shortcut to move window to workspace 5.";
				};

				moveToWorkspace6 = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>6";
					description = "Shortcut to move window to workspace 6.";
				};

				moveToWorkspace7 = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>7";
					description = "Shortcut to move window to workspace 7.";
				};

				moveToWorkspace8 = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>8";
					description = "Shortcut to move window to workspace 8.";
				};

				moveToWorkspace9 = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>9";
					description = "Shortcut to move window to workspace 9.";
				};


				moveToWorkspaceLeft = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep><left>";
					description = "Shortcut to move window one workspace to the left.";
				};

				moveToWorkspaceRight = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep><right>";
					description = "Shortcut to move window one workspace to the right.";
				};

			};

			# Applications

			apps = {

				close = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>q";
					description = "Shortcut to close the active app.";
				};

				switch = lib.mkOption {
					type = lib.types.str;
					default = "<alt><sep><tab>";
					description = "Shortcut to switch to the next app.";
				};

				switchBackward = lib.mkOption {
					type = lib.types.str;
					default = "<alt><shift><sep><tab>";
					description = "Shortcut to switch to the previous app.";
				};

				switchToAppLeft = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep><left>";
					description = "Shortcut to switch to the app on the left.";
				};

				switchToAppRight = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep><right>";
					description = "Shortcut to switch to the app on the right.";
				};

				switchToAppUp = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep><up>";
					description = "Shortcut to switch to the app above.";
				};

				switchToAppDown = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep><down>";
					description = "Shortcut to switch to the app below.";
				};

				fullscreen = lib.mkOption {
					type = lib.types.str;
					default = "<sep><f11>";
					description = "Shortcut to switch to fullscreen mode.";
				};

				activeOnAllWorkspaces = lib.mkOption {
					type = lib.types.str;
					default = "<super><control><sep>t";
					description = "Shortcut to keep app on all workspaces.";
				};

				launchSettings = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>i";
					description = "Shortcut to launch the settings app.";
				};

				launchExplorer = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>e";
					description = "Shortcut to launch the file explorer.";
				};

				launchTerminal = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>c";
					description = "Shortcut to launch the terminal.";
				};

				launchBrowser = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>b";
					description = "Shortcut to launch the web browser.";
				};

				launchAppLauncher = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep><space>";
					description = "Shortcut to launch the application launcher.";
				};


			};

			# Workspaces

			workspaces = {

				switchToWorkspace1 = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>1";
					description = "Shortcut to switch to workspace 1.";
				};

				switchToWorkspace2 = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>2";
					description = "Shortcut to switch to workspace 2.";
				};

				switchToWorkspace3 = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>3";
					description = "Shortcut to switch to workspace 3.";
				};

				switchToWorkspace4 = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>4";
					description = "Shortcut to switch to workspace 4.";
				};

				switchToWorkspace5 = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>5";
					description = "Shortcut to switch to workspace 5.";
				};

				switchToWorkspace6 = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>6";
					description = "Shortcut to switch to workspace 6.";
				};

				switchToWorkspace7 = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>7";
					description = "Shortcut to switch to workspace 7.";
				};

				switchToWorkspace8 = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>8";
					description = "Shortcut to switch to workspace 8.";
				};

				switchToWorkspace9 = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>9";
					description = "Shortcut to switch to workspace 9.";
				};

				switchToWorkspaceLeft = lib.mkOption {
					type = lib.types.str;
					default = "<super><ctrl><sep><left>";
					description = "Shortcut to switch to the previous workspace.";
				};

				switchToWorkspaceRight = lib.mkOption {
					type = lib.types.str;
					default = "<super><ctrl><sep><right>";
					description = "Shortcut to switch to the next workspace.";
				};

			};

			# DE
			de = {

				showDesktop = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>d";
					description = "Shortcut to show the desktop.";
				};

				lockScreen = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>l";
					description = "Shortcut to lock the screen.";
				};

				# Screenshots

				screenshot = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>s";
					description = "Shortcut to make a screenshot.";
				};

				quickScreenshot = lib.mkOption {
					type = lib.types.str;
					default = "<super><ctrl><shift><sep>s";
					description = "Shortcut to quickly make a screenshot.";
				};

				quickScreenshotWindow = lib.mkOption {
					type = lib.types.str;
					default = "<super><alt><shift><sep>s";
					description = "Shortcut to quickly make a screenshot of the active window.";
				};

				# Notifications

				focusActiveNotification = lib.mkOption {
					type = lib.types.str;
					default = "<super><shift><sep>n";
					description = "Shortcut to focus the active notification.";
				};

				openNotificationPanel = lib.mkOption {
					type = lib.types.str;
					default = "<super><sep>n";
					description = "Shortcut to open the notification panel.";
				};

			};
			
		};

		# A dedicated option to hold our mapping function, making it accessible
		# to other modules. Placing it under a custom namespace in `lib` is a
		# common convention for utility functions.
		custom.shortcuts.map = lib.mkOption {
			type = lib.types.functionTo (lib.types.functionTo lib.types.str);
			internal = true; # This indicates it's a utility for other modules.
			description = "Maps abstract shortcut syntax to DE-specific syntax.";
		};
	};

		# Section for setting the values of options
	config = {
		# Assign our local mappingFunction to the option we just defined.
		# Now, any other module can access it via `config.lib.custom.shortcuts.map`.
		custom.shortcuts.map = mappingFunction;
	};
}
