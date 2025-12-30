{ config, lib, ... }:
{
	options.packages.defaults.lockscreen = {

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available lockscreens.";
		};

		active = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.packages.defaults.lockscreen.available or []));
			default = null;
			description = "Set the active default lockscreens.";
		};

		launchCommand = lib.mkOption {
			type = lib.types.str;
			default = config.packages.defaults.lockscreen.active or "";
			description = "Define a custom launch command for the lockscreens.";
		};
	};
}