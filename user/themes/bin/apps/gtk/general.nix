{ config, lib, ... }:
{
	config = {
		home-manager.users.${config.user.settings.username} = {
			gtk = lib.mkIf (config.theming.useStylix == false) {
				enable = true;

				theme.name = config.theming.baseGTKTheme.name;
				theme.package = config.theming.baseGTKTheme.package;
			};

		};

		stylix.targets.gtk.enable = true;
	};
} 
