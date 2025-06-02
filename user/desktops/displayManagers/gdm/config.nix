{ config, lib, ... }:
{
	config = lib.mkIf (config.displayManagers.activeManager == "gdm") {
		services.displayManager.gdm.enable = lib.mkForce true;
	};
}