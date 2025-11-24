{ config, lib, ... }:
{
	config = {
		assertions = [
			{
				assertion = (config.theming.wallpaper.type != "single") || (config.theming.wallpaper.single.active != null);
				message = "Single Wallpaper is enabled but not set.";
			}
		];

		stylix = lib.mkIf ((config.theming.wallpaper.type == "single") && config.theming.useStylix) {
			wallpaper = config.theming.wallpaper.single.active;
		};
	};
}