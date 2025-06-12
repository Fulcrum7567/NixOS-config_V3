{ config, pkgs, ... }:
{
	config = {

		# Mouse wheel
		environment.systemPackages = with pkgs; [
			piper
		];
		#programs.piper.enable = true;

		# The piper module should automatically pull in services.ratbagd.enable = true;
		# but you can add it explicitly if you encounter issues.
		# services.ratbagd.enable = true;


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