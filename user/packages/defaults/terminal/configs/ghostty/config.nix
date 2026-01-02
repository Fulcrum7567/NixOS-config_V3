{ config, lib, ... }:
{
	config = lib.mkIf (config.packages.defaults.terminal.active == "ghostty") {
		packages = {
			defaults = {
				terminal.appID = "com.mitchellh.ghostty.desktop";
				terminal.launchAtPathCommand = "ghostty --working-directory=\"<path>\"";
				terminal.launchCommand = "ghostty";
			};

			ghostty.enable = true;
		};
	};
}