{ config, ... }:
{
		
		# Remove mimeapps list
		home-manager.backupFileExtension = "backup";

		system.userActivationScripts = {
		  	removeConflictingFiles = {
		    	text = ''
		      		rm -f /home/${config.user.settings.username}/.config/mimeapps.list.backup
		    	'';
		  	};
		};


		
		home-manager.users.${config.user.settings.username} = {

			xdg.userDirs = {
				enable = true;
				createDirectories = true;
			};

			
			xdg.configFile."mimeapps.list".force = true;
			xdg.configFile."gtk-4.0/settings.ini".force = true;

			home.username = config.user.settings.username;
  			home.homeDirectory = "/home/${config.user.settings.username}";

  			# This value determines the Home Manager release that your configuration is
			# compatible with. This helps avoid breakage when a new Home Manager release
			# introduces backwards incompatible changes.
			#
			# You should not change this value, even if you update Home Manager. If you do
			# want to update the value, then make sure to first check the Home Manager
			# release notes.
			home.stateVersion = "24.11"; # Please read the comment before changing.



			# Let Home Manager install and manage itself.
  			programs.home-manager.enable = true;
		};
}