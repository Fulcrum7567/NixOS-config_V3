{ config, pkgs, pkgs-unstable, ... }:
{
	config = {

		#nix-diff
		environment.systemPackages = with pkgs; [
			nix-diff
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