{ config, lib, ... }:
{
	config = lib.mkIf (config.desktops.activeDesktop == "sddmWithHyprland") {
		displayManagers.activeManager = "sddm";
		desktopEnvironments.hyprland.hyprlandBase.enable = true;
	};
}