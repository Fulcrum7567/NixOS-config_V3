{ config, lib, ... }:
{
	options.packages.defaults.terminal = {

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available terminals.";
		};

		active = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.packages.defaults.terminal.available or []));
			default = null;
			description = "Set the active default terminal.";
		};

		appID = lib.mkOption {
			type = lib.types.str;
			default = "";
			description = "Define the app id of the set terminal";
			example = "zen-beta.desktop";
		};

		launchAtPathCommand = lib.mkOption {
			type = lib.types.str;
			default = "";
			description = "Command to launch the terminal at given path.";
			example = "kitty -d";
		};
	};
}