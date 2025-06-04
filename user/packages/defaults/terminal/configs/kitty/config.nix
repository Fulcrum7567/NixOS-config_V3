{ config, lib, ... }:
{
	config = lib.mkIf (config.defaults.terminal.enable && (config.defaults.terminal.active == "kitty")) {
		defaults.terminal.appID = "kitty.desktop";
		defaults.terminal.launchAtPathCommand = "kitty -d";
		packages.kitty.enable = true;
	};
}