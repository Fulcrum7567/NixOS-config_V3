{ config, lib, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.simpleGnome.enable {
		
		desktopEnvironments.gnome = {
			# Based on gnome base
			gnomeBase.enable = true;

			settings = {
				keyboardShortcuts.enable = true;
			};

			extensions = {
				alphabeticalAppGrid.enable = true;
				appIndicator.enable = true;
				blurMyShell.enable = true;
				clipboardIndicator.enable = true;
				dashToDock.enable = true;
				grandTheftFocus.enable = true;
				justPerfection.enable = false; # BROKEN!
				middleClickClose.enable = true;
				windowTitleIsBack.enable = true;
			};
		};
	};
}