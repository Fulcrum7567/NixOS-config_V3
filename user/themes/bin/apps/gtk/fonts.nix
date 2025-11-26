{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.gtk.fonts.override) {
		gtk = {
			font = {
				name = config.theming.gtk.fonts.value.sansSerif.name;
				size = config.theming.gtk.fonts.value.sizes.applications;
			};
		};

		dconf.settings = {
			"org/gnome/desktop/interface" = {
				document-font-name = "${config.theming.gtk.fonts.value.sansSerif.name} ${toString config.theming.gtk.fonts.value.sizes.applications}";

				monospace-font-name = "${config.theming.gtk.fonts.value.monospace.name} ${toString config.theming.gtk.fonts.value.sizes.applications}";
			};
		};
	};
} 
