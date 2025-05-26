{ config, lib, ... }:
{
	options.packages.zen = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
			description = "Whether to enable zen-browser.";
		};
	};

} 
