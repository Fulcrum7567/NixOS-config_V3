{ config, pkgs, pkgs-unstable, lib, ... }:
{
	config = {

		services.tailscale.enable = true;


		# VR
		programs.immersed.enable = true;


		# Immersed requires hardware acceleration for encoding the stream
		hardware.graphics = {
			enable = true;
			# specific libraries often needed for VAAPI/NVENC encoding
			extraPackages = with pkgs; [
				libva
				libva-vdpau-driver
			];
		};


		home-manager.users.${config.user.settings.username} = {

			

			#switch audio
			dconf.settings = {
		        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
		            name = "Switch audio output";
		            command = "bash ${config.host.settings.dotfilesDir}/system/switchAudioOutput.sh";
		            binding = "<Control><Alt>KP_Left";
		        };

		        "org/gnome/settings-daemon/plugins/media-keys" = {
		            custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" ];
		        };
		    };
		};

	};
}
