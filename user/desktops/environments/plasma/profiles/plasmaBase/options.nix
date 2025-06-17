{ config, lib, ... }:
{
	options.desktopEnvironments.plasma.plasmaBase = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable 'plasma base' desktop environment";
		};
	};
}