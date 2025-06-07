{ config, lib, ... }:
{
	config = lib.mkIf (config.packages.defaults.editor.active == "sublime") {
		packages.defaults.editor.appID = "sublime_text.desktop";
		packages.sublime.enable = true;
	};
}