{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		packages.flatpak.enable = true;

		services.flatpak.packages = [
			{
				appId = "com.ultimaker.cura";
				origin = "flathub";
			}
		];
	};
}