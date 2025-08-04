{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = {
		gtk.font.name = "${config.theming.fonts.sansSerif.name} ${config.theming.fonts.sizes.applications}";
	};
} 
