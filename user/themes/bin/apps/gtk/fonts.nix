{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.useStylix == false) {
		gtk = {
			font = {
				name = config.theming.fonts.sansSerif.name;
				size = config.theming.fonts.sizes.applications;
			};
		};

		dconf.settings = {
			"org/gnome/desktop/interface" = {
				document-font-name = "${config.theming.fonts.sansSerif.name} ${toString config.theming.fonts.sizes.applications}";

				monospace-font-name = "${config.theming.fonts.monospace.name} ${toString config.theming.fonts.sizes.applications}";
			};
		};
	};
} 
