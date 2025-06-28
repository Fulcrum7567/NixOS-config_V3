{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		boot.kernelModules = [ "i2c-dev" ];
		environment.systemPackages = with pkgs; [
		  	ddcutil
		  	ddcui
		];
		users.groups.i2c.members = [ config.user.settings.username ];

		services.udev.extraRules = ''
		  # Grant read/write access to i2c devices for the i2c group
		  SUBSYSTEM=="i2c-dev", GROUP="i2c", MODE="0660"
		'';

		desktopEnvironments.gnome.extensions.brightnessControl = lib.mkIf option.enableGnomeExtension {
			enable = true;
		};

	};
} 
