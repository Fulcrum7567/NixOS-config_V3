{ config, lib, ... }: {
	
	config = {
		host.settings = {
			systemType = "laptop";
			gpuManufacturer = "nvidia";
			dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
			hashedPassword = "$6$swTYGVRP4erDVWWO$argE8karkQ6JyNFAEgFMiJpEYCYrIIZChmqrvXUb0VDx7lS./U661Agnv1mwJVrlx1x.ShGaznfrbgdsrdqBW0";
		};
		theming.activeTheme = "nord";
		desktops.activeDesktop = "gnomeWithGdm";

		packages = {
			signal.enable = true;
			supergfxd.enable = true;
			groups = {
				gaming = {
					enable = true;
					active = "noDroidcam";
				};
				programming.enable = true;
				FH.enable = true;
			};
		};

		hosts = {
			fixes = {
				bluetooth.enable = true;
				suspend.enable = true;
				touchpad.enable = true;
				sdCardReader.enable = true;
			};

			components = {

				kernelVersion = {
					enable = true;
					activeConfig = "latest";
				};
			
				nvidiaDrivers = {
					enable = true;
					powerManagement = "finegrained";

					activeConfig = "prime";
					intelBusId = "PCI:0:2:0";
					nvidiaBusId = "PCI:1:0:0";
				};

			};
		};
	};


}