{ config, lib, ... }:
{
	options.packages.defaults.explorer = {

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available explorers.";
		};

		active = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.packages.defaults.explorer.available or []));
			default = null;
			description = "Set the active default explorer.";
		};

		appID = lib.mkOption {
			type = lib.types.str;
			default = "";
			description = "Define the app id of the set explorer";
			example = "zen-beta.desktop";
		};
	};

}