{ config, lib, ... }: {

	imports = [] ++ lib.optional (builtins.pathExists ./autoSetups/disko.nix) ./autoSetups/disko.nix;
	
	config = {
		host.settings = {
			systemType = "server";
			dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
			hashedPassword = "$6$swTYGVRP4erDVWWO$argE8karkQ6JyNFAEgFMiJpEYCYrIIZChmqrvXUb0VDx7lS./U661Agnv1mwJVrlx1x.ShGaznfrbgdsrdqBW0";
		};

		hardware.displays = {
		};

		server = {

			webaddress = "aurek.eu";

			services = {

				reverseProxy = {
					enable = true;
					activeConfig = "nginx";
				};

				autoBackup = {
					enable = true;
					activeConfig = "default";
				};

				immich = {
					enable = true;
					exposeGUI = true;
				};

				syncthing = {
					enable = true;
					exposeGUI = true;
				};
			};
		};

		packages = {
			neovim = {
				enable = true;
				activeConfig = "nvf";
			};

			docker.enable = true;

		};

		displayManagers.activeManager = null;
		desktops.activeDesktop = null;
		desktops.sessionType = null;
		theming = {
			activeTheme = null;
			useStylix = false;

			cursors = {
				active = null;
				package = null;
				name = null;
			};

			fonts = {
				monospace = {
					config = null;
					package = null;
					name = null;
				};
				sansSerif = {
					config = null;
					package = null;
					name = null;
				};
				serif = {
					config = null;
					package = null;
					name = null;
				};
			};

			icons = {
				active = null;
				package = null;
				name = null;
			};

			wallpaper.type = null;
		};

		hosts = {
			fixes = {
			};

			components = {

				shutdownTimes = {
					enable = true;
					shutdownAt = "22:00";
					wakeUpAt = "06:00";
				};

				bootEntryLabels.enable = false;

				kernelVersion = {
					enable = false;
				};
			};
		};
	};


}
