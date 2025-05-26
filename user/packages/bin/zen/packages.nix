{ config, lib, zen-browser, ... }:
{
	config = lib.mkIf config.packages.zen.enable {

		environment.systemPackages = [
			zen-browser.packages."${hostSettings.system}".default
		];
	};
} 
