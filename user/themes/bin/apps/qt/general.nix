{ config, lib, pkgs, ... }:
{
	config = {
		home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.activeTheme != null) {
			home.packages = with pkgs; [
				adwaita-qt
			];
			qt = lib.mkIf (config.theming.useStylix == false) {
				enable = true;
				platformTheme.name = "gtk";
				style = {
					name = config.theming.baseQtTheme.name;
					package = config.theming.baseQtTheme.package;
				};
			};
		};

		stylix.targets.qt.enable = false;
	};
} 
