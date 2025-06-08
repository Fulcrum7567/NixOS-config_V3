{ config, ... }: {
	
	config = {
		host.settings = {
			systemType = "laptop";
			gpuManufacturer = "nvidia";
			dotfilesDir = "/home/${config.user.settings.username}/Documents/Nixos-Config_V3";
			hashedPassword = "$6$swTYGVRP4erDVWWO$argE8karkQ6JyNFAEgFMiJpEYCYrIIZChmqrvXUb0VDx7lS./U661Agnv1mwJVrlx1x.ShGaznfrbgdsrdqBW0";
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