{ config, ... }: {
	
	config = {
		host.settings = {
			systemType = "desktop";
			gpuManufacturer = "nvidia";
			dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
			hashedPassword = "$6$LndFR/AR7MoTwWAT$Mt8cqxGvTAKlHTJ8zZyOnJOwZ6r0RsSw4bM9i.Wx8eQwidFdyMSEoYOFc29Egbpbzg2lhPULwziIOapSMU/lY0";
		};
		theming.activeTheme = "nord";
		desktops.activeDesktop = "gnomeWithGdm";
		packages.groups = {
			gaming.enable = true;
			FH.enable = true;
		};
		hosts.components = {
			nvidiaDrivers = {
				enable = true;
				powerManagement = "enabled";
			};
		};
	};


}