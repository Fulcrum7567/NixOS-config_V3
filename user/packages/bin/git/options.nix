{ config, lib, ... }:
{
	options.packages.git = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
			description = "Whether to enable git.";
		};

		storeCredentials = lib.mkOption {
			type = lib.types.bool;
			default = true;
			description = "Whether to save git credentials on host.";
		};
	};

} 
