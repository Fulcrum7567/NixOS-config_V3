{ config, lib, ... }:
{
	config = lib.mkIf (config.displayManagers.activeManager == "sddm") {
		services.displayManager.sddm = {
			enable = true;
			wayland.enable = true;
		};
		services.xserver.displayManager.gdm.enable = lib.mkForce false;

	};
}