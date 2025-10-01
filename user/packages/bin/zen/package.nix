{ config, lib, zen-browser, ... }:
{
  config.home-manager.users.${config.user.settings.username} = {
    imports = [
		  zen-browser.homeModules.beta
	  ];
  };
  
}