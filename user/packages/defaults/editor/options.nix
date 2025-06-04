{ config, lib, ... }:
{
	options.defaults.editor = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
			description = "Whether to enable a default editors.";
		};

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

	config = lib.mkIf (config.defaults.editor.enable && (config.defaults.editor.active == null)) {
		warnings = [ "A default editor is enabled but no active editor is set. Set an active editor with config.defaults.editor.active." ]; 
	};
}