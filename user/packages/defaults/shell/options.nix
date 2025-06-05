{ config, lib, ... }:
{
	options.defaults.shell = {

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available shells.";
		};

		active = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.defaults.shell.available or []));
			default = null;
			description = "Set the active default shell.";
		};

		initPrompt = lib.mkOption {
			type = lib.types.str;
			default = "[\u@\h \W]\$ ";
			description = "Set the prompt of the shell.";
		};
	};
}