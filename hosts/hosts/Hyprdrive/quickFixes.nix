{ config, pkgs, pkgs-unstable, ... }:
{
	config = {

		environment.systemPackages = with pkgs-unstable; [
			libinput
		];

		# Ollama
		services.ollama = {
			enable = false;
			acceleration = "cuda";
			models = "/mnt/HDD/AI/Ollama/Models";
			loadModels = [
				"deepseek-r1:70b"
			];
		};

		# Mouse wheel

		services.udev.packages = [
			(pkgs.writeTextFile {
				name = "libinput-quirks-g903";
				destination = "/lib/udev/libinput/quirks/91-logitech-g903.quirks";
				text = ''
					[Logitech G903 Lightspeed]
					MatchName=Logitech G903*
					AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
				'';
			})
		];
		/*
services.udev.extraRules = ''
  # Hyper-specific rule for Logitech G903 using hardware IDs to disable hi-res scrolling.
  ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{id/vendor}=="046d", ATTRS{id/product}=="4087", ENV{LIBINPUT_ATTR_WHEEL_HI_RES_HW}="0"
'';


		
		services.libinput.enable = true;


		*/
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