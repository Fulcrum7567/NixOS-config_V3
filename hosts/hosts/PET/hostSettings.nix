{ config, ... }: {
	
	config = {
		host.settings = {
			systemType = "laptop";
			gpuManufacturer = "nvidia";
			dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
		};
		theming.activeTheme = "nord";
		desktops.activeDesktop = "gnomeWithGdm";
		packages.groups = {
			gaming.enable = false;
			FH.enable = true;
		};
		hosts.fixes = {
			bluetooth.enable = true;
			suspend.enable = true;
			touchpad.enable = true;
		};
	};


}