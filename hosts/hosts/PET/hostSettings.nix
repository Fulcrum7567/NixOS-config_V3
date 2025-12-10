{ config, lib, ... }: {
	
	config = {
		host.settings = {
			systemType = "laptop";
			gpuManufacturer = "nvidia";
			dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
			hashedPassword = "$6$swTYGVRP4erDVWWO$argE8karkQ6JyNFAEgFMiJpEYCYrIIZChmqrvXUb0VDx7lS./U661Agnv1mwJVrlx1x.ShGaznfrbgdsrdqBW0";
		};
		theming.activeTheme = "nord";
		desktops.activeDesktop = "gdmWithGnome";


		hardware.displays = {
			Builtin = {
				primary = true;
				resolution = "1920x1200";
				position = "0x0";
				refreshRate = 60;
				name = "eDP-1";
			};
		};

		packages = {
			signal.enable = true;
			supergfxd.enable = true;

			mullvad = {
				enable = true;
				autoEnableDelay = -1;
			};

			docker.enable = lib.mkForce true;

			
			cubeIDE.enable = false;

			bitwarden.enable = true;

			groups = {
				gaming = {
					enable = false;
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

				

				fingerprint.enable = true;

				kernelVersion = {
					enable = true;
					activeConfig = "zen";
				};
			
				nvidiaDrivers = {
					enable = true;
					package = config.boot.kernelPackages.nvidiaPackages.beta;
					powerManagement = "finegrained";

					activeConfig = "prime";
					intelBusId = "PCI:0:2:0";
					nvidiaBusId = "PCI:1:0:0";
				};

			};
		};
	};


}
