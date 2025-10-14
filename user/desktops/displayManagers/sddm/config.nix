{ config, lib, pkgs, ... }:
{
	config = lib.mkIf (config.displayManagers.activeManager == "sddm") {
		services.displayManager.sddm = {
			enable = true;
			wayland.enable = true; 
			autoNumlock = true;
		};
		
		services.displayManager.gdm.enable = lib.mkForce false;
		

	};
}