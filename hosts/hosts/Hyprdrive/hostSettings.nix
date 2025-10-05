{ config, lib, ... }: {
	
	config = {
		host.settings = {
			systemType = "desktop";
			gpuManufacturer = "amd";
			dotfilesDir = "/home/${config.user.settings.username}/.dotfiles";
			hashedPassword = "$6$LndFR/AR7MoTwWAT$Mt8cqxGvTAKlHTJ8zZyOnJOwZ6r0RsSw4bM9i.Wx8eQwidFdyMSEoYOFc29Egbpbzg2lhPULwziIOapSMU/lY0";
		};

		
		theming = {
			activeTheme = "nord";
		};

		
		desktops.activeDesktop = "sddmWithHyprland";

		hardware.displays = {
			LG-UltraGear = {
				primary = true;
				resolution = "2560x1440";
				position = "0x0";
				refreshRate = 144;
				name = "DP-2";
			};
			ACER = {
				resolution = "1920x1080";
				position = "2560x80";
				refreshRate = 60;
				name = "HDMI-A-2";
			};
		};


		packages = {
			signal.enable = true;
			vscode.enable = true;

			solaar.enable = true;

			sunshine.enable = true;
			moonlight.enable = lib.mkForce false;

			mullvad = {
				enable = true;
				autoEnableDelay = 300;
			};

			groups = {
				gaming.enable = true;
				FH.enable = true;
				printing.enable = false;
			};
		};




		hosts.components = {

			monitorBrightness.enable = true;

			kernelVersion = {
				enable = true;
				activeConfig = "lqx";
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
