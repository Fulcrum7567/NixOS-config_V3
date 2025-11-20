{ config, lib, ... }:
{
  config = {
    home-manager.users.${config.user.settings.username}.stylix.targets.zen-browser.profileNames = [ "default" config.user.settings.username ];
	};
}