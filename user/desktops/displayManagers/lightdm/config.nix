{ config, lib, pkgs, ... }:
{
	config = lib.mkIf (config.displayManagers.activeManager == "lightdm") {
		services.xserver.displayManager.lightdm = {
			enable = true;
		};
		
		services.displayManager.gdm.enable = lib.mkForce false;
		
		
	};
}