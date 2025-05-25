{ config, lib, ... }:
{
	options.packages.sops.enable = lib.mkOption {
		type = lib.types.bool;
		default = true;
		description = "Whether to enable sops.";
	};
} 
