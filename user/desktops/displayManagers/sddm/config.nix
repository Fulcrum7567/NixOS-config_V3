{ config, lib, pkgs, ... }:
{
	config = lib.mkIf (config.displayManagers.activeManager == "sddm") {
		services.displayManager.sddm = {
			enable = true;
			wayland.enable = true; 
		};
		
		hosts.components.fingerprint.enable = lib.mkForce false;

		services.displayManager.gdm.enable = lib.mkForce false;
		
		
	};
}