/*
	Quick, ugly fixes not meant to keep


*/
{ lib, config, pkgs, ... }:
{
	config = {

		# fix for suspend?
		boot.kernelParams = [ "button.lid_init_state=open" ];

		# Swap-file
		swapDevices = [
			{
				device = "/swapfile";
				size = 16 * 1024;
			}
		];

		# Set the power button behavior to suspend
		services.logind.settings.Login = {
			HandlePowerKey = "suspend";

			# Optional: Handle the short press vs long press if needed
			HandlePowerKeyLongPress = "poweroff";
		};
	};
}