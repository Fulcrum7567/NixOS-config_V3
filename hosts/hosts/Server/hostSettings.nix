{ config, lib, ... }: {
	
	config = {
		host.settings = {
			systemType = "server";
			dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
			hashedPassword = "$6$swTYGVRP4erDVWWO$argE8karkQ6JyNFAEgFMiJpEYCYrIIZChmqrvXUb0VDx7lS./U661Agnv1mwJVrlx1x.ShGaznfrbgdsrdqBW0";
		};

		hardware.displays = {
		};

		packages = {
			nvf.enable = true;

			docker.enable = true;
		};

		hosts = {
			fixes = {
			};

			components = {

				kernelVersion = {
					enable = false;
				};
			};
		};
	};


}
