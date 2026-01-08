{ config, lib, pkgs, ... }:
{
	config = lib.mkIf (config.displayManagers.activeManager == "sddm") {
		services.displayManager.sddm = {
			enable = true;
			wayland.enable = true; 
			autoNumlock = true; # Not working https://github.com/NixOS/nixpkgs/issues/403259
		};
		
		services.displayManager.gdm.enable = lib.mkForce false;
		

	};
}