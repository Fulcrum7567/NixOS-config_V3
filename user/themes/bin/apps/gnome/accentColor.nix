{ config, lib, ... }:
{
  	config = lib.mkIf (config.theming.gnome.enable) {
    	home-manager.users.${config.user.settings.username} = {
      		dconf.settings = {
        		"org/gnome/desktop/interface" = lib.mkIf (config.theming.gnome.accentColor != null) {
          			accent-color = config.theming.gnome.accentColor;
        		};
      		};
    	};

		warnings = lib.mkIf (config.theming.gnome.accentColor == null) [
			"GNOME accent color is not set. Default accent color will be used."
		];
  	};
}