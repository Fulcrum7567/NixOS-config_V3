{ config, ... }: {
	
	config.host.settings = {
		systemType = "desktop";
		defaultPackageState = "unstable";
		gpuManufacturer = "nvidia";
		dotfilesDir = /home/${config.user.settings.username}/.dotfiles;
	};
}