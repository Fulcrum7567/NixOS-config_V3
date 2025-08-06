{ config, lib, ... }:
{
	config.home-manager.users.${config.user.settings.username} = {
		programs.kitty.font = {
			package = config.theming.fonts.monospace.package;
			name = config.theming.fonts.monospace.name;
			size = config.theming.fonts.sizes.terminal;
		};
	};
} 
