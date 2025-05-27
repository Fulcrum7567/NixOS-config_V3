{ config, ... }: {
	
	config.host.settings = {
		systemType = "desktop";
		gpuManufacturer = "nvidia";
		dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
	};
}