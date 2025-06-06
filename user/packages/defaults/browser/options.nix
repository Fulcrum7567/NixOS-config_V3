{ config, lib, ... }:
{
	options.packages.defaults.browser = {

		availableBrowsers = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available browsers.";
		};

		active = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.packages.defaults.browser.availableBrowsers or []));
			default = null;
			description = "Set the active default Browser.";
		};

		appID = lib.mkOption {
			type = lib.types.str;
			default = "";
			description = "Define the app id of the set browser";
			example = "zen-beta.desktop";
		};
	};
}