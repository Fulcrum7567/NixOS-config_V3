{ config, lib, ... }:
{
	options.defaults.browser = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
			description = "Whether to enable a default browser.";
		};

		availableBrowsers = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available browsers.";
		};

		active = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.defaults.browser.availableBrowsers or []));
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

	config = lib.mkIf (config.defaults.browser.enable && (config.defaults.browser.active == null)) {
		warnings = [ "A default browser is enabled but no active browser is set. Set an active browser with config.defaults.browser.active." ]; 
	};
}