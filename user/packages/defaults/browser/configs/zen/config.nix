{ config, lib, ... }:
{
	config = lib.mkIf (config.defaults.browser.enable && (config.defaults.browser.active == "zen")) {
		defaults.browser.appID = "zen-beta.desktop";
		packages.zen.enable = true;
	};
}