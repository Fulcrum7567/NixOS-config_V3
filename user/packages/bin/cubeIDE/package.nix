{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		packages.flatpak.enable = true;

		services.flatpak.packages = [
			{
				appId = "com.st.STM32CubeIDE";
				origin = "flathub";
			}
		];

		environment.systemPackages = with pkgs-default; [
			stlink-gui
			gnumake
			gnat15
		];

		services.udev.packages = with pkgs-default; [
			stlink
    		openocd
		];

		users.users.${config.user.settings.username}.extraGroups = [ "plugdev" "dialout" ];

		users.extraGroups.plugdev = {};

		services.udev.extraRules = ''
		# STM32 ST-Link/V2 (vendor:product 0483:3748)
		ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666", GROUP="plugdev"
		'';
	};
}