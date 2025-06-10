{ config, lib, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.simpleGnome.enable {
		
		desktopEnvironments.gnome = {
			# Based on gnome base
			gnomeBase.enable = true;

			settings = {
				fileChooser.enable = true;
				interface.enable = true;
				keyboardShortcuts.enable = true;
				mutter.enable = true;
				shell.enable = true;
				touchpad.enable = true;
				wm.enable = true;
				disableApps.enable = true;
				notifications.enable = true;
			};

			extensions = {
				alphabeticalAppGrid.enable = true;
				appIndicator.enable = true;
				blurMyShell.enable = true;
				clipboardIndicator.enable = true;
				dashToDock.enable = true;
				grandTheftFocus.enable = true;
				hibernateStatusButton.enable = true;
				justPerfection.enable = false; # BROKEN!
				middleClickClose.enable = true;
				windowTitleIsBack.enable = true;
			};
		};
	};
}