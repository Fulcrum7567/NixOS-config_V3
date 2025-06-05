{ config, lib, ... }:
{
	options.defaults.editor = {

		available = lib.mkOption {
			type = lib.types.listOf lib.types.str;
			default = [];
			apply = x: lib.unique x;
			description = "List of all available editors.";
		};

		active = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum (config.defaults.editor.available or []));
			default = null;
			description = "Set the active default editor.";
		};

		appID = lib.mkOption {
			type = lib.types.str;
			default = "";
			description = "Define the app id of the set editor";
			example = "zen-beta.desktop";
		};
	};

}