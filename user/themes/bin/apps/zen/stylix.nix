{ config, lib, ... }:
{
  config = lib.mkIf ((config.theming.activeTheme != null) && config.theming.useStylix) {
    home-manager.users.${config.user.settings.username}.stylix.targets.zen-browser.profileNames = [ "default" ];
	};
}