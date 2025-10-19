{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		# Fingerprint reader
		services.fwupd.enable = true;
		# 1. Enable the fingerprint daemon
		services.fprintd.enable = true;

		# 2. Specify the driver for the ELAN fingerprint sensor
		# This enables the Touch OEM Driver (TOD) support required by the ELAN sensor
		services.fprintd.tod.enable = true;
		services.fprintd.tod.driver = pkgs-default.libfprint-2-tod1-elan;

		# 3. Configure PAM for GDM to allow both fingerprint and password login
		security.pam.services.gdm.fprintAuth = true;

		# Optional but recommended: Allow fingerprint authentication for sudo
		security.pam.services.sudo.fprintAuth = true;

	};
} 
