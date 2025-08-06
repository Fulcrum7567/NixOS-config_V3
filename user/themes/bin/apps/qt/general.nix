{ config, lib, pkgs, ... }:
{
	config.home-manager.users.${config.user.settings.username} = {
		home.packages = with pkgs; [
			adwaita-qt
		];
		qt = {
			enable = true;
			platformTheme.name = "gtk";
			style.name = config.theming.baseQtTheme;
		};
	};
} 
