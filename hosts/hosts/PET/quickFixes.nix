/*
	Quick, ugly fixes not meant to keep


*/
{ lib, config, pkgs, ... }:
{
	config = {

		# Swap-file
		swapDevices = [
			{
				device = "/swapfile";
				size = 16 * 1024;
			}
		];
	};
}