{ config, lib, pkgs, ... }: {
	
	config = {
		host.settings = {
			systemType = "desktop";
			gpuManufacturer = "amd";
			dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
			hashedPassword = "$6$LndFR/AR7MoTwWAT$Mt8cqxGvTAKlHTJ8zZyOnJOwZ6r0RsSw4bM9i.Wx8eQwidFdyMSEoYOFc29Egbpbzg2lhPULwziIOapSMU/lY0";
			hibernateWorking = false;
			suspendWorking = true;
		};

		
		theming = {
			activeTheme = "nord";
		};

		
		desktops.activeDesktop = "gdmWithGnome";

		hardware.displays = {
			LG-UltraGear = {
				primary = true;
				resolution = "2560x1440";
				position = "0x0";
				refreshRate = 144;
				name = "DP-3";
			};
			ACER = {
				resolution = "1920x1080";
				position = "2560x80";
				refreshRate = 60;
				name = "HDMI-A-1";
			};
		};

		desktopEnvironments.hyprland.bin.input.synchronizedWorkspaces = true;


		packages = {

			syncthing = {
				enable = true;
				activeConfig = "Hyprdrive";
			};

			signal.enable = true;
			vscode.enable = true;

			alvr.enable = true;

			solaar.enable = true;

			sunshine.enable = true;
			moonlight.enable = lib.mkForce false;

			bottles.enable = true;

			neovim = {
				enable = true;
				activeConfig = "nvf";
			};


			mullvad = {
				enable = true;
				autoEnableDelay = 30;
			};

			groups = {
				gaming.enable = true;
				FH.enable = true;
				printing.enable = false;
			};
		};




		hosts = {

			fixes = {
				suspend = {
					enable = true;
					activeConfig = "hyprdrive";
				};
			};
			
			components = {

				monitorBrightness.enable = true;

				amdDrivers.enable = true;

				kernelVersion = {
					enable = false;
					activeConfig = "cachy";
					cachy.version = pkgs.linuxPackages_cachyos-lts;
				};

				scheduler = {
					enable = false;
					activeConfig = "scx";
				};

				wakeOnLan = {
					enable = true;
					interface = "eno1";
				};
			};
		};
		
		
		# Drives:
		fileSystems."/mnt/SSD-Games" = {
		  	device = "/dev/nvme0n1p5";
		  	fsType = "ext4";
		  	options = [ "defaults" ];
		};
		
		
		fileSystems."/mnt/HDD" = {
		  	device = "/dev/disk/by-uuid/f5d38b42-7564-4996-931a-89758fa4ee0d";
		  	fsType = "ext4";
		  	options = [ "defaults" ];
		};
		
	};


}
