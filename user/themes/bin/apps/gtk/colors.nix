{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.gtk.colors.override) {
		xdg.configFile = {
			"gtk-3.0/gtk.css".text = config.theming.gtk.colors.value;
			"gtk-4.0/gtk.css".text = config.theming.gtk.colors.value;
		};

		home.sessionVariables.GTK_THEME = config.theming.baseGTKTheme.name;
	};
} 
