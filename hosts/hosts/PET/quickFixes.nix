/*
	Quick, ugly fixes not meant to keep


*/
{ lib, config, pkgs, ... }:
{
	config = {
		services.desktopManager.gnome.enable = true;
		services.displayManager.gdm.enable = true;


		# Fingerprint reader
		services.fwupd.enable = true;
		# 1. Enable the fingerprint daemon
		services.fprintd.enable = true;

		# 2. Specify the driver for the ELAN fingerprint sensor
		# This enables the Touch OEM Driver (TOD) support required by the ELAN sensor
		# services.fprintd.tod.enable = true;
		# services.fprintd.tod.driver = pkgs.libfprint-2-tod1-elan;

		# 3. Configure PAM for GDM to allow both fingerprint and password login
		security.pam.services.gdm.fprintAuth = true;

		# Optional but recommended: Allow fingerprint authentication for sudo
		security.pam.services.sudo.fprintAuth = true;
	};



}