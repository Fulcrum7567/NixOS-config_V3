{ config, lib, settings, ... }:
{
	options.packages.groups.${settings.optionName} = {

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available ${settings.optionName} groups configs.";
		};

		active = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.packages.groups.${settings.optionName}.available or []));
			default = null;
			description = "Set the active ${settings.optionName} group config.";
		};

		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Activate the ${settings.optionName} group.";
		};
	};
}