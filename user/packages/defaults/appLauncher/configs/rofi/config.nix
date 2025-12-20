{ config, lib, ... }:
{
	config = lib.mkIf (config.packages.defaults.appLauncher.active == "rofi") {
		packages = {
			defaults = {
				appLauncher.appID = "";
				appLauncher.launchCommand = "rofi -show drun -theme-str \"entry{placeholder:'Search Applications...';}listview{lines:9;}\" -theme /home/fulcrum/.config/rofi/launchers/type-2/style-2.rasi";
			};
			
			rofi.enable = true;
		};
	};
}