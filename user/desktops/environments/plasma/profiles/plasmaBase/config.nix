{ config, lib, pkgs, ... }:
{
	config = lib.mkIf config.desktopEnvironments.plasma.plasmaBase.enable {
		services.desktopManager.plasma6.enable = true;
		services.desktopManager.gnome.enable = lib.mkForce false;

		services.displayManager.sddm.package = lib.mkForce pkgs.kdePackages.sddm;

		boot.kernelParams = [ "nvidia-drm.modeset=1" ];

		xdg.portal = {
	      	enable = true;
	      	extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
	    };

		environment.systemPackages = with pkgs; [
		    kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
		    kdePackages.kcalc # Calculator
		    kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
		    kdePackages.kcolorchooser # A small utility to select a color
		    kdePackages.kolourpaint # Easy-to-use paint program
		    kdePackages.ksystemlog # KDE SystemLog Application
		    kdePackages.sddm-kcm # Configuration module for SDDM
		    kdiff3 # Compares and merges 2 or 3 files or directories
		    kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
		    kdePackages.partitionmanager # Optional Manage the disk devices, partitions and file systems on your computer
		    hardinfo2 # System information and benchmarks for Linux systems
		    haruna # Open source video player built with Qt/QML and libmpv
		    wayland-utils # Wayland utilities
		    wl-clipboard # Command-line copy/paste utilities for Wayland
		    kdePackages.kde-gtk-config
			kdePackages.plasma-desktop
			kdePackages.plasma-wayland-protocols
			kdePackages.plasma-workspace
		];

		systemd.services."xdg-desktop-portal-gnome" = {
			wantedBy = lib.mkForce [];
		};

		
		
		#theming.useStylix = lib.mkForce false;

		theming.wallpaper.diashow.selectCommand = ''
			qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
				var allDesktops = desktops();
				print (allDesktops);
				for (i=0;i<allDesktops.length;i++) {{
						d = allDesktops[i];
						d.wallpaperPlugin = "org.kde.image";
						d.currentConfigGroup = Array("Wallpaper",
																				"org.kde.image",
																				"General");
						d.writeConfig("Image", "file:///<wallpaperPath>");
				}}
		'
		'';


		desktops.sessionType = "wayland";
		
		packages = {
			kdeConnect.enable = lib.mkForce false;
		};
		
		programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
		
	};
}