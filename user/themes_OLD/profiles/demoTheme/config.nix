{ config, lib, ... }:
{


	config = lib.mkIf (config.theming.activeTheme == "demoTheme") {
		theming = {
			components = {
				plymouth = {
					enable = true;
					active = "mikuboot";
				};
			};

		};
	};
}