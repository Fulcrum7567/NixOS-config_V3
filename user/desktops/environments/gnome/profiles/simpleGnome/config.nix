{ config, lib, ... }:
{
	config = lib.mkIf config.desktopEnvironments.gnome.simpleGnome.enable {
		
		desktopEnvironments.gnome = {
			# Based on gnome base
			gnomeBase.enable = true;

			extensions = {
				blurMyShell.enable = true;
				alphabeticalAppGrid.enable = true;
				clipboardIndicator.enable = true;
				dashToDock.enable = true;
				justPerfection.enable = false; # BROKEN!
			};
		};
	};
}