{ config, lib, ... }:
{
	config = lib.mkIf (config.displayManagers.activeManager == "gdm") {
		services.displayManager.gdm.enable = true;
		programs.dconf.profiles.gdm.databases = [{
			settings."org/gnome/desktop/peripherals/keyboard" = {
				numlock-state = true;
			};
		}];
	};
}