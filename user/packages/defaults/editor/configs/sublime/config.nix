{ config, lib, ... }:
{
	config = lib.mkIf (config.defaults.editor.enable && (config.defaults.editor.active == "sublime")) {
		defaults.editor.appID = "sublime_text.desktop";
		packages.sublime.enable = true;
	};
}