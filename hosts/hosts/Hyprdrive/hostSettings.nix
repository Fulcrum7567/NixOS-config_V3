{ config, ... }: {
	
	config = {
		host.settings = {
			systemType = "desktop";
			gpuManufacturer = "nvidia";
			dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
			hashedPassword = "$6$LndFR/AR7MoTwWAT$Mt8cqxGvTAKlHTJ8zZyOnJOwZ6r0RsSw4bM9i.Wx8eQwidFdyMSEoYOFc29Egbpbzg2lhPULwziIOapSMU/lY0";
		};

		
		theming = {
			activeTheme = "nord";
			components = {
				plymouth.active = "mikuboot";
			};
		};
		desktops.activeDesktop = "gnomeWithGdm";
		packages = {
			signal.enable = true;
			vscode.enable = true;

			mullvad.enable = true;

			groups = {
				gaming.enable = true;
				FH.enable = true;
			};
		};
		hosts.components = {

			monitorBrightness.enable = true;

			kernelVersion = {
				enable = true;
				activeConfig = "latest";
			};

			nvidiaDrivers = {
				enable = true;
				powerManagement = "enabled";
			};

			wakeOnLan = {
				enable = true;
				interface = "eno1";
			};
		};

		# Drives:
		fileSystems."/mnt/SSD-Games" = {
		  	device = "/dev/nvme0n1p5";
		  	fsType = "ext4";
		  	options = [ "defaults" ];
		};

		fileSystems."/mnt/HDD" = {
		  	device = "/dev/disk/by-uuid/DC0673760673508E";
		  	fsType = "ntfs-3g";
		  	options = [ "uid=1000" "gid=1000" "umask=0022" "windows_names" "big_writes" ];
		};
	};


}