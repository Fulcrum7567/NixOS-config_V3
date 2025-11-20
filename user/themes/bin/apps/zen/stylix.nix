{ config, lib, ... }:
{
  config = {
    home-manager.user.${config.user.settings.username}.stylix.targets.zen-browser.profileNames = [ "default" config.user.settings.username ];
	};
}