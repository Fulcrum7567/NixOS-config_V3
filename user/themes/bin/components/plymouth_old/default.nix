{ config, lib, options, ... }:
{
	options.theming.plymouth.enable = lib.mkOption {
		type = lib.types.bool;
		default = true;
		description = "Whether to enable plymouth.";
	};

	config = lib.mkIf config.theming.plymouth.enable {
		boot.plymouth.enable = true;
	};
}