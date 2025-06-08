{ config, lib, pkgs-default, ... }:
{
	config = lib.mkIf (config.theming.colorScheme == "nord") {
		stylix.base16Scheme = "${pkgs-default.base16-schemes}/share/themes/nord.yaml";

		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {
				"org/gnome/desktop/interface" = {
			    	accent-color = "slate";
			    };
		    };
		};
	};
}