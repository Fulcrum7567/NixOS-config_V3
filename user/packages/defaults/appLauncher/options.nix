{ config, lib, ... }:
{
	options.packages.defaults.appLauncher = {

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available application launchers.";
		};

		active = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.packages.defaults.appLauncher.available or []));
			default = null;
			description = "Set the active default application launcher.";
		};

		appID = lib.mkOption {
			type = lib.types.str;
			default = "";
			description = "Define the app id of the set terminal";
			example = "zen-beta.desktop";
		};


		launchCommand = lib.mkOption {
			type = lib.types.str;
			default = config.packages.defaults.appLauncher.active or "";
			description = "Define a custom launch command for the application launcher.";
		};
	};
}