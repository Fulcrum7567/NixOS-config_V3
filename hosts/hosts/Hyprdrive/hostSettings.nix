{ config, ... }: {
	
	config = {
		host.settings = {
			systemType = "desktop";
			gpuManufacturer = "nvidia";
			dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
		};
		theming.activeTheme = "demoTheme";
		desktops.activeDesktop = "gnomeWithGdm";
		groups = {
			gaming.enable = true;
			FH.enable = true;
		};
		hosts.fixes = {
			touchpad.enable = true;
			suspend.enable = true;
		};
	};


}