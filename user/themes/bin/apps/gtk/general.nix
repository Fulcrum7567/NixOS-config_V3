{ config, lib, ... }:
{
	config = {
		home-manager.users.${config.user.settings.username} = lib.mkIf (config.theming.activeTheme != null) {
			gtk = lib.mkIf ((config.theming.baseGTKTheme != null) && (config.stylix.targets.gtk.enable == false)) {
				enable = true;

				theme.name = lib.mkForce config.theming.baseGTKTheme.name;
				theme.package = lib.mkForce config.theming.baseGTKTheme.package;
			};

		};

		stylix.targets.gtk.enable = lib.mkDefault true;
	};
} 
