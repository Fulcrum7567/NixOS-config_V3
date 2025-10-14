{ config, lib, ... }:
let
	gnomePolarity = (if (config.theming.polarity == "dark") then "prefer-dark" else (if (config.theming.polarity == "light") then "prefer-light" else "default"));
in
{
	config = {
		home-manager.users.${config.user.settings.username} = {
			dconf.settings = {
				"org/gnome/desktop/interface" = {
					color-scheme = gnomePolarity;
				};

				"org/gnome/desktop/interface" = {
					accent-color = "slate";
				};
			};
		};
	};
} 
