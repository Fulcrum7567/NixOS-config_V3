{ config, lib, ... }:
{
	config = lib.mkIf (config.packages.defaults.browser.active == "zen") {
		packages.defaults.browser = {
			appID = "zen-beta.desktop";
			launchCommand = "zen";
		};
		packages.zen.enable = true;
	};
}