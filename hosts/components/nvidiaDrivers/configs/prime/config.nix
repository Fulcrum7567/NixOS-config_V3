{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
	option = config.hosts.components.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "prime")) {

		# Enable OpenGL
		hardware.graphics = {
			enable = true;
			enable32Bit = true;
			extraPackages = [
			    pkgs.vulkan-loader
			    pkgs.vulkan-validation-layers
		  	];
		};

		# Load nvidia driver for Xorg and Wayland
		services.xserver.videoDrivers = [ "nvidia" ];

		hardware.nvidia = {

			# Modesetting is required.
			modesetting.enable = true;

			# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
			# Enable this if you have graphical corruption issues or application crashes after waking
			# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
			# of just the bare essentials.
			powerManagement.enable = ((config.hosts.components.nvidiaDrivers.powerManagement == "enabled") || (config.hosts.components.nvidiaDrivers.powerManagement == "finegrained"));

			# Fine-grained power management. Turns off GPU when not in use.
			# Experimental and only works on modern Nvidia GPUs (Turing or newer).
			powerManagement.finegrained = (config.hosts.components.nvidiaDrivers.powerManagement == "finegrained");

			# Use the NVidia open source kernel module (not to be confused with the
			# independent third-party "nouveau" open source driver).
			# Support is limited to the Turing and later architectures. Full list of 
			# supported GPUs is at: 
			# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
			# Only available from driver 515.43.04+
			open = true;

			# Enable the Nvidia settings menu,
			# accessible via `nvidia-settings`.
			nvidiaSettings = config.hosts.components.nvidiaDrivers.nvidiaSettings;

			# Optionally, you may need to select the appropriate driver version for your specific GPU.
			package = config.hosts.components.nvidiaDrivers.package;

			dynamicBoost.enable = config.hosts.components.nvidiaDrivers.dynamicBoost;

			prime = {
				offload = {
					enable = true;
					enableOffloadCmd = true;
				};
				intelBusId = config.hosts.components.nvidiaDrivers.intelBusId;
				nvidiaBusId = config.hosts.components.nvidiaDrivers.nvidiaBusId;
			};
		};
	};
} 
