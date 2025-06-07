{ config, ... }: {
	
	config = {
		host.settings = {
			systemType = "desktop";
			gpuManufacturer = "nvidia";
			dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
		};
		theming.activeTheme = "nord";
		desktops.activeDesktop = "gnomeWithGdm";
		packages.groups = {
			gaming.enable = true;
			FH.enable = true;
		};
		hosts.fixes = {
		};
	};


}