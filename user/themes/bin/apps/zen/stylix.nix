{ config, lib, ... }:
{
  config = {
		stylix.targets.zen-browser.profileNames = [ "default" config.user.settings.username ];
	};
}