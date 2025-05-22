{ config, lib, ... }:
{
	options.custom.hyprland.enable = lib.mkOption {
		type = lib.types.bool;
		default = false;
		description = "Whether to enable hyprland."
	};
} 
