{ config, lib, ... }:
{
	options.desktopEnvironments.hyprland.hyprlandBase = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable 'hyprland base' desktop environment";
		};
	};
}