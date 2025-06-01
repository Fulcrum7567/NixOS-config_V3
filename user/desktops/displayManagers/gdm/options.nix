{ config, lib, ... }:
{
	options.displayManagers.gdm = {
		enable = lib.mkOption {
			type = lib.types.boolean;
		};
	};
} 
