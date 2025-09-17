{ config, lib, ... }:
{
	config = {
		assertions = [
			{
				assertion = true;
				message = "Single Wallpaper is enabled but not set.";
			}
		];
	};
}