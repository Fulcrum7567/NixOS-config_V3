{ config, lib, ... }:
{
	config = lib.mkIf config.desktopEnvironments.plasma.plasmaBase.enable {
		services.desktopManager.plasma6.enable = true;
	};
}