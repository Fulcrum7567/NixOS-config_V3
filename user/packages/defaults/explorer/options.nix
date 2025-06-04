{ config, lib, ... }:
{
	options.defaults.explorer = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
			description = "Whether to enable a default explorer.";
		};

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available explorers.";
		};

		active = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.defaults.explorer.available or []));
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

	config = lib.mkIf (config.defaults.explorer.enable && (config.defaults.explorer.active == null)) {
		warnings = [ "A default explorer is enabled but no active explorer is set. Set an active explorer with config.defaults.explorer.active." ]; 
	};
}