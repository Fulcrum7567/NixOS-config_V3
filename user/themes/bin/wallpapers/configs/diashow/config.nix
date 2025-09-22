{ config, lib, ... }:
{
	config = {
		assertions = [
			{
				assertion = (config.theming.wallpaper.type != "diashow") || (config.theming.wallpaper.diashow.active != null);
				message = "Diashow Wallpaper is enabled but not set.";
			}
			{
				assertion = (config.theming.wallpaper.type != "diashow") || (config.theming.wallpaper.diashow.selectCommand != null);
				message = "Diashow Wallpaper is enabled but no command to select one is set.";
			}
		];
	};
}