{ config, lib, ... }:
{
	config = lib.mkIf (config.packages.defaults.terminal.active == "kitty") {
		packages = {
			defaults = {
				terminal.appID = "kitty.desktop";
				terminal.launchAtPathCommand = "kitty -d";
				terminal.launchCommand = "kitty";
				terminal.launchWithCommand = "kitty -e <command>";
			};
			
			kitty.enable = true;
		};
	};
}