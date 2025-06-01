{ config, lib, ... }:
{
	options.displayManagers = {

		availableManagers = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available display managers. Every manager adds itself to this list.";
		};

		activeManager = lib.mkOption {
			type = lib.types.enum (config.displayManagers.availableManagers or []);
			description = "Set the active display manager. Must exist in user/desktop/displayManagers.";
		};
	};
}