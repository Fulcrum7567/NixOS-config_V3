{ config, lib, ... }:
{
	config = lib.mkIf (config.packages.defaults.editor.active == "sublime") {
		packages.defaults.editor = {
			appID = "sublime_text.desktop";
			launchCommand = "sublime";
		};
		packages.sublime.enable = true;
	};
}